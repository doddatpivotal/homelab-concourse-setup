# Usage: ./scripts/delete-bosh.sh [vcenter_password]
# Example: ./scripts/delete-bosh.sh $VCENTER_PASSWORD

source scripts/bosh-env.sh

bosh delete-env local-cache/bosh-deployment/bosh.yml \
    --state=generated/bosh/state.json \
    --vars-store=generated/bosh/creds.yml \
    -o local-cache/bosh-deployment/vsphere/cpi.yml \
    -o local-cache/bosh-deployment/jumpbox-user.yml \
    -o bosh/operations/custom-dns-server.yml \
    -v vcenter_password=$1 \
    -l vars/bosh-director-params.yml

