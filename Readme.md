# Concourse Installation at homelab

The following guide walks through setting up Concourse for PCF on homelab.  This is for demo and sandbox activities only and does not represent a production ready implementation. The following Pivotal documentation drove this effort: https://docs.pivotal.io/p-concourse/installing.html
The process should take about 30 minutes

## Setup

Get the supported credhub version from [Concourse for PCF docs](https://docs.pivotal.io/p-concourse/4-x/index.html#compatibility)

>NOTE: Update the tag version in ./scripts/clone-source-git-repos.sh

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

1. Setup alias and update the bosh/cloud-config.yml file

```bash
./scripts/configure-bosh.sh
```

## Concourse Installation

Now you are ready for the concourse installation.

1. Use Pivnet to retrieve stemcells and then upload into bosh

>See [Concourse Compatibility](https://docs.pivotal.io/p-concourse/index.html#compatibility) for supported stemcells

Identify the stemcell version and slug

Download stemcell (this is to ensure you have accepted the eula)

Your token may be found at ~/.pivnetrc

```bash
./scripts/retrieve-and-upload-stemcell.sh $PIVNET_API_TOKEN $XENIAL_VERSION $XENIAL_SLUG
```

>Example `./scripts/retrieve-and-upload-stemcell.sh $PIVNET_API_TOKEN 250.29 352509`

1. Deploy Concourse

Get the supported credhub version from [Concourse for PCF docs](https://docs.pivotal.io/p-concourse/4-x/index.html#compatibility)
Go to bosh.io to get the sha1 for the version
Check that you have the right versions of concourse, postgres, uaa, and garden_runc while you are at it

Update the variables with specifics from your environment

Helpful guides:

- [For use of oauth and uuaa](https://github.com/concourse/concourse-bosh-deployment/pull/85)
- [For credhub and concourse integration](https://github.com/pivotal-cf/pcf-pipelines/blob/master/docs/credhub-integration.md)

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

# Go to the url presented in the login prompt and authenticate with the newly created user
# using fly and chome on seperate computers, go to /sky/token and copy the content of the page and then enter into the fly prompt for token

fly -t lab set-team -n team-uaa-oauth --oauth-user concourse --non-interactive

credhub api https://ci.lab.winterfell.live:8844 --ca-cert <(bosh int generated/concourse/concourse-gen-vars.yml --path /atc_tls/ca)

export CREDHUB_SECRET=$(bosh int generated/concourse/concourse-gen-vars.yml --path /credhub_admin_secret)

credhub login --client-name credhub_admin

credhub set --type value --name '/concourse/main/hello' --value 'World'

fly -t lab set-pipeline -p hello-credhub -c test-pipeline/pipeline.yaml -n

fly -t lab unpause-pipeline -p hello-credhub

fly -t lab trigger-job -j hello-credhub/hello-credhub -w

```

>If you see "Hello World" at the end then you passed your test!

## Populate Credhub with Secrets

./scripts/seed-credhub.redacted.sh can be renamed to seed-credhub.sh (which is listed in .gitignore).  With that, you can replace redacted secrets with those that you want to put in credhub.  This will be necessary for the platform automation activity

## Teardown

```bash
./scripts/delete-concourse.sh
./scripts/delete-bosh.sh $ACCESS_KEY_ID $SECRET_ACCESS_KEY
```

## Upgrade from 4.2 to 5.x

Folling from [docs](https://docs.pivotal.io/p-concourse/v5/upgrade-from-4/backups/)

```bash
bosh \
upload-release \
--sha1 364838c384f2edec80866b4abf2397c4c5d15c62 \
https://bosh.io/d/github.com/cloudfoundry-incubator/backup-and-restore-sdk-release?v=1.15.1
```
