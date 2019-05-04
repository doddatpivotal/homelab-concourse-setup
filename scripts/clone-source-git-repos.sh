rm -rf local-cache
mkdir local-cache
cd local-cache
git clone https://github.com/cloudfoundry/bosh-deployment.git
git clone https://github.com/concourse/concourse-bosh-deployment.git
cd concourse-bosh-deployment
git checkout tags/v4.2.3