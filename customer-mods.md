# Modifications for customer installation where concourse subnet has no internet access

## BOSH Modifications

No resource pools for bosh configuration

- updated `/scripts/create-bosh.sh` removing resource pool operations file
- updated `/scripts/delete-bosh.sh` removing resource pool operations file

Add ssh access to for bosh director

- updated `/scripts/create-bosh.sh` to call jumpbox-user operations file
- updated `/scripts/delete-bosh.sh` to call jumpbox-user operations file

Add operation for custom dns server

- updated `/vars/bosh-director-params.yml` to specify custom dns server ip
- created `/bosh/operations/custom-dns.server.yml` set dns value to a passed in variable
- updated `/scripts/create-bosh.sh` to call new operations file
- updated `/scripts/delete-bosh.sh` to call new operations file

## Concourse Modifications

Created script to retrieve and upload concourse releases

- created `/scripts/retrieve-and-upload-concourse-releases.sh`

Add operation to leverage pre-uploaded releases

- created `/concourse/operations/pre-uploaded-releases.yml` to remove url and sha1 references for releases
- updated `/scripts/deploy-concourse.yml` to use new operations file
