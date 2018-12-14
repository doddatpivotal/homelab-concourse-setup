source scripts/bosh-env.sh

bosh -e bosh-concourse -d concourse -n \
  deploy concourse/concourse.yml \
  -o ../local-cache/concourse-bosh-deployment/cluster/operations/add-main-team-oauth-users.yml \
  -o ../local-cache/concourse-bosh-deployment/cluster/operations/static-web.yml \
  -o concourse/operations/uaa.yml \
  -o concourse/operations/credhub.yml \
  -o concourse/operations/tls-vars.yml \
  -o ../local-cache/concourse-bosh-deployment/cluster/operations/privileged-https.yml \
  -o ../local-cache/concourse-bosh-deployment/cluster/operations/tls.yml \
  -o ../local-cache/concourse-bosh-deployment/cluster/operations/uaa-generic-oauth-provider.yml \
  -l vars/concourse-params.yml \
  -l vars/concourse-versions.yml \
  --vars-store=generated/concourse/concourse-gen-vars.yml