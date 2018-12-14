# Concourse Installation at homelab

The following guide walks through setting up Concourse for PCF on homelab.  This is for demo and sandbox activities only and does not represent a production ready implementation. The following Pivotal documentation drove this effort: https://docs.pivotal.io/p-concourse/installing.html
The process should take about 30 minutes

## Setup

```bash
./scripts/clone-source-git-repos.sh
```

## Bosh Director Installation

First you need to setup a dedicated BOSH director for Concourse.  The following steps were guided by http://bosh.io/docs/init-vsphere/.

1. Create the bosh environment

You will need to update the variables passed in below with the ones provided by your environment

```bash
./scripts/create-bosh.sh $VCENTER_PASSWORD
```

>Example ./scripts/create-bosh.sh foopassword

1. Setup alias and update the cloud config

```bash
./scripts/configure-bosh.sh
```

## Concourse Installation

Now you are ready for the concourse installation.

1. Use Pivnet to retrieve stemcells and then upload into bosh

Log into Pivnet
Download 97 stemcell **may have to update release version and identifier**
>See [Concourse Compatibility](https://docs.pivotal.io/p-concourse/index.html#compatibility) for supported stemcells

Your token may be found at ~/.pivnetrc

Get the supported XENIAL_VERSION from [Concourse for PCF docs](https://docs.pivotal.io/p-concourse/4-x/index.html#compatibility)

```bash
./scripts/retrieve-and-upload-stemcell.sh $PIVNET_API_TOKEN $XENIAL_VERSION $XENIAL_SLUG
```

>Example `./scripts/retrieve-and-upload-stemcell.sh $PIVNET_API_TOKEN 97.41 276961`

1. Deploy Concourse

Get the supported credhub version from [Concourse for PCF docs](https://docs.pivotal.io/p-concourse/4-x/index.html#compatibility)
Go to bosh.io to get the sha1 for the version
Check that you have the right versions of concourse, postgres, uaa, and garden_runc while you are at it

Update the variables with specifics from your environment

Helpful guides:

- [For use of oauth and uuaa](https://github.com/concourse/concourse-bosh-deployment/pull/85)
- [For credhub and concourse integration](https://github.com/pivotal-cf/pcf-pipelines/blob/master/docs/credhub-integration.md)

For a non-uaa/credhub solution...

```bash
bosh -e bosh-1 deploy -d concourse ./concourse-bosh-deployment/cluster/concourse.yml \
  -l ./concourse-bosh-deployment/versions.yml \
  --vars-store ./concourse-bosh-deployment/cluster/cluster-creds.yml \
  -o ./concourse-bosh-deployment/cluster/operations/static-web.yml \
  -o ./concourse-bosh-deployment/cluster/operations/basic-auth.yml \
  -o ./concourse-bosh-deployment/cluster/operations/privileged-http.yml \
  --var local_user.username=admin \
  --var local_user.password=REDACTED_PASSWORD \
  --var web_ip=192.168.72.181 \
  --var az=az1 \
  --var external_url=http://ci.lab.winterfell.live \
  --var network_name=concourse \
  --var web_vm_type=small \
  --var db_vm_type=small \
  --var db_persistent_disk_type=10240 \
  --var worker_vm_type=medium.disk \
  --var deployment_name=concourse
```

For a uaa/credhub solution...

```bash
./scripts/deploy-concourse.sh
```

1. Create concourse user

```bash
./scripts/create-concourse-user.sh $CONCOURSE_HOST $CONCOURSE_USER $CONCOURSE_USER_PASSWORD
```

>Example: `./scripts/create-concourse-user.sh ci.lab.winterfell.live concourse PasswOrd`

1. Test access

```bash
fly login -t lab -c https://ci.lab.winterfell.live -k

fly -t lab set-team -n team-uaa-oauth --oauth-user concourse --non-interactive

credhub api https://ci.lab.winterfell.live:8844 --ca-cert <(bosh int generated/concourse/concourse-gen-vars.yml --path /atc_tls/ca)

export CREDHUB_PASSWORD=$(bosh int generated/concourse/concourse-gen-vars.yml --path /uaa_users_admin)

credhub login -u admin -p "$CREDHUB_PASSWORD"

credhub set --type value --name '/concourse/main/hello' --value 'World'

fly -t lab set-pipeline -p hello-credhub -c test-pipeline/pipeline.yaml -n

fly -t lab unpause-pipeline -p hello-credhub

fly -t lab trigger-job -j hello-credhub/hello-credhub -w

```

1. Access concourse

**you will need to be on vpn**
You can visit concourse at http://ci.lab.winterfell.live and use the following to setup local fly target
```
fly --target lab login --concourse-url http://ci.lab.winterfell.live
```