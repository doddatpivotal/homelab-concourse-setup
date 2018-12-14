# Usage: ./scripts/retrieve-and-upload-stemcell.sh [api-token] [version] [id]
# Example: ./scripts/retrieve-and-upload-stemcell.sh TOKEN 97.41 276961

pivnet login --api-token=$1
mkdir ../local-cache/releases
pivnet accept-eula -p stemcells -r $2
pivnet download-product-files -p stemcells-ubuntu-xenial -r $2 -i $3 -d ../local-cache/releases/

source scripts/bosh-env.sh

bosh -e bosh-concourse upload-stemcell ../local-cache/releases/bosh-stemcell-$2-vsphere-esxi-ubuntu-xenial-go_agent.tgz
