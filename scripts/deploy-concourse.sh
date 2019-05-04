source scripts/bosh-env.sh

bosh -e bosh-concourse -d concourse -n \
  deploy local-cache/concourse-bosh-deployment/cluster/concourse.yml \
  -o local-cache/concourse-bosh-deployment/cluster/operations/add-main-team-oauth-users.yml \
  -o local-cache/concourse-bosh-deployment/cluster/operations/static-web.yml \
  -o local-cache/concourse-bosh-deployment/cluster/operations/uaa.yml \
  -o concourse/operations/uaa-additions.yml \
  -o concourse/operations/credhub.yml \
  -o local-cache/concourse-bosh-deployment/cluster/operations/tls.yml \
  -o local-cache/concourse-bosh-deployment/cluster/operations/tls-vars.yml \
  -o concourse/operations/tls-additions.yml \
  -o local-cache/concourse-bosh-deployment/cluster/operations/privileged-https.yml \
  -o local-cache/concourse-bosh-deployment/cluster/operations/uaa-generic-oauth-provider.yml \
  -o concourse/operations/static-db-additions.yml \
  -l vars/concourse-params.yml \
  -l local-cache/concourse-bosh-deployment/versions.yml \
  -l vars/concourse-versions.yml \
  --vars-store=generated/concourse/concourse-gen-vars.yml