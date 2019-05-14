# Usage: ./scripts/create-bosh.sh [vcenter-password]
# Example: ./scripts/create-bosh.sh PASSWORD

bosh create-env local-cache/bosh-deployment/bosh.yml \
    --state=generated/bosh/state.json \
    --vars-store=generated/bosh/creds.yml \
    -o local-cache/bosh-deployment/vsphere/cpi.yml \
    -o local-cache/bosh-deployment/jumpbox-user.yml \
    -o bosh/operations/custom-dns-server.yml \
    -o bosh/operations/custom-ntp-server.yml \
    -v vcenter_password=$1 \
    -l vars/bosh-director-params.yml

