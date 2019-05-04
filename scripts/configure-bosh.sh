source scripts/bosh-env.sh

bosh -e bosh-concourse log-in
bosh -e bosh-concourse update-cloud-config bosh/cloud-config.yml -n