source scripts/bosh-env.sh

curl -L https://bosh.io/d/github.com/pivotal-cf/credhub-release?v=1.9.5 -o local-cache/releases/credhub-release-1.9.5.tgz
bosh -e bosh-concourse upload-release local-cache/releases/credhub-release-1.9.5.tgz

curl -L https://bosh.io/d/github.com/concourse/concourse-bosh-release?v=4.2.3 -o local-cache/releases/concourse-bosh-release-4.2.3.tgz
bosh -e bosh-concourse upload-release local-cache/releases/concourse-bosh-release-4.2.3.tgz

curl -L https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.18.2 -o local-cache/releases/garden-runc-release-1.18.2.tgz
bosh -e bosh-concourse upload-release local-cache/releases/garden-runc-release-1.18.2.tgz

curl -L https://bosh.io/d/github.com/cloudfoundry/postgres-release?v=30 -o local-cache/releases/postgres-release-30.tgz
bosh -e bosh-concourse upload-release local-cache/releases/postgres-release-30.tgz

curl -L https://bosh.io/d/github.com/cloudfoundry/uaa-release?v=72.0 -o local-cache/releases/uaa-release-72.0.tgz
bosh -e bosh-concourse upload-release local-cache/releases/uaa-release-72.0.tgz
