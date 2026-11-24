#!/usr/bin/env bash
set -uo pipefail
SN=$(sed -n 's/^service_name *= *"\(.*\)"/\1/p' core/terraform.tfvars)
API=https://eu.api.ovh.com/v1
TOKEN=$(curl -s -X POST https://www.ovh.com/auth/oauth2/token \
  --data-urlencode grant_type=client_credentials \
  --data-urlencode "client_id=$OVH_CLIENT_ID" \
  --data-urlencode "client_secret=$OVH_CLIENT_SECRET" \
  --data-urlencode scope=all | jq -r .access_token)
[ -n "$TOKEN" ] && [ "$TOKEN" != null ] || { echo "Could not get an OVH token"; exit 1; }
get() { curl -s -H "Authorization: Bearer $TOKEN" "$API$1"; }
section() { echo; echo "=================== $1"; }

section "Project users (code has ONE: achrona-scrolls-app)"
get "/cloud/project/$SN/user" | jq -r '.[] | "\(.id)\t\(.username)\t\(.description)\troles=\([.roles[].name]|join(","))\t\(.status)"'

section "S3 policy + keys of every user"
for id in $(get "/cloud/project/$SN/user" | jq -r '.[].id'); do
  echo "--- user $id"; get "/cloud/project/$SN/user/$id/policy" | jq -c . 2>/dev/null
  echo "    S3 keys:"; get "/cloud/project/$SN/user/$id/s3Credentials" | jq -r '.[]?.access' | sed 's/^/      /'
done

section "S3 buckets in GRA (encryption / versioning)"
for b in $(get "/cloud/project/$SN/region/GRA/storage" | jq -r '.[].name'); do
  get "/cloud/project/$SN/region/GRA/storage/$b" | jq -c '{name, encryption, versioning, objectsCount, tags}'
done

section "Instances (code has NONE besides kube nodes)"
get "/cloud/project/$SN/instance" | jq -r '.[] | "\(.name)\t\(.flavorId)\t\(.status)\t\(.region)"'

section "Private networks (code has ONE: achrona-net)"
get "/cloud/project/$SN/network/private" | jq -r '.[] | "\(.id)\t\(.name)\tvlan=\(.vlanId)"'

section "Kubernetes clusters, node pools, IP restrictions"
for k in $(get "/cloud/project/$SN/kube" | jq -r '.[]'); do
  get "/cloud/project/$SN/kube/$k" | jq -c '{name, version, updatePolicy, status}'
  get "/cloud/project/$SN/kube/$k/nodepool" | jq -r '.[] | "  pool \(.name)\t\(.flavor)\tmin=\(.minNodes) max=\(.maxNodes)"'
  echo "  ipRestrictions:"; get "/cloud/project/$SN/kube/$k/ipRestrictions" | jq -c .
done

section "Container registries and users (code has ONE user: scribe)"
for r in $(get "/cloud/project/$SN/containerRegistry" | jq -r '.[].id'); do
  get "/cloud/project/$SN/containerRegistry/$r" | jq -c '{name, status, url}'
  get "/cloud/project/$SN/containerRegistry/$r/users" | jq -r '.[] | "  user \(.user)\t\(.email)"'
done
