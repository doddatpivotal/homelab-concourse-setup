
credhub api https://ci.lab.winterfell.live:8844 --ca-cert <(bosh int generated/concourse/concourse-gen-vars.yml --path /atc_tls/ca)
export CREDHUB_PASSWORD=$(bosh int generated/concourse/concourse-gen-vars.yml --path /uaa_users_admin)
credhub login -u admin -p "$CREDHUB_PASSWORD"

# Concourse main team credentials
credhub set -t value -n '/concourse/main/s3_access_key_id' -v 'REDACTED_ACCESS_KEY_D'
credhub set -t value -n '/concourse/main/s3_secret_access_key' -v 'REDACTED_SECRET_ACCESS_KEY'
credhub set -t value -n '/concourse/main/pivnet_token' -v 'REDACED_PIVNET_TOKEN'
credhub set -t rsa -n '/concourse/main/configuration_git_repo' -p configuration_private_key.cert
credhub set -t rsa -n '/concourse/main/platform_automation_example_git_repo' -p configuration_private_key2.cert
credhub set -t rsa -n '/concourse/main/platform_automation_example_locks_git_repo' -p configuration_private_key3.cert
credhub set -t certificate -n '/concourse/main/credhub_ca_cert' -c <(bosh int ../homelab-concourse-setup/generated/concourse/concourse-gen-vars.yml --path /atc_tls/ca)
credhub set -t value -n '/concourse/main/credhub_secret' -v $(bosh int ../homelab-concourse-setup/generated/concourse/concourse-gen-vars.yml --path /uaa_users_admin)
credhub set -t value -n '/concourse/main/concourse_to_credhub_secret' -v $(bosh int ../homelab-concourse-setup/generated/concourse/concourse-gen-vars.yml --path /concourse_to_credhub_secret)
credhub set -t value -n '/concourse/main/general_password' -v 'REDACTED'
credhub set -t value -n '/concourse/main/cf_mgmt_client_secret' -v 'REDACTED'
credhub set -t value -n '/concourse/main/ldap_bind_user_password' -v 'REDACTED'

# Platform Automation credentials for the lab foundation
credhub set -t value -n '/lab-foundation/s3_access_key_id' -v 'REDACTED'
credhub set -t value -n '/lab-foundation/s3_secret_access_key' -v 'REDACTED'
credhub set -t value -n '/lab-foundation/vsphere_ssh_public_key' -v 'REDACTED_RSA_PUB_KEY'
credhub set -t value -n '/lab-foundation/vsphere_vcenter_password' -v 'REDACTED_VCENTER_PW'
credhub set -t value -n '/lab-foundation/wavefront_token' -v 'REDACTED_TOKEN'
credhub set -t value -n '/lab-foundation/uaa_ldap_password' -v 'REDACTED_PASSWORD'
credhub set -t value -n '/lab-foundation/properties_credhub_key_encryption_passwords_0_key_secret' -v 'REDACTED_ENCRYPTION_KEY'
credhub set -t value -n '/lab-foundation/pivnet_token' -v 'REDACTED'
credhub set -t value -n '/lab-foundation/opsman_username' -v 'REDACTED'
credhub set -t value -n '/lab-foundation/opsman_password' -v 'REDACTED'
credhub set -t value -n '/lab-foundation/opsman_decryption_passphrase' -v 'REDACTED'
