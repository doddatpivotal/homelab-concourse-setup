# Usage: ./scripts/create-concourse-user.sh [concourse-host] [user] [password]
# Example: ./scripts/create-concourse-user.sh ci.lab.winterfell.live concourse PASSWORD

uaac target https://$1:8443 --skip-ssl-validation
export UAA_ADMIN_PASSWORD=$(bosh int generated/concourse/concourse-gen-vars.yml --path /uaa_admin)
uaac token client get admin --secret $UAA_ADMIN_PASSWORD
uaac user add $2 --emails $1 -p $3
