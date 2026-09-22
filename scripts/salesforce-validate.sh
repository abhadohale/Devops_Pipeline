#!/usr/bin/env bash
set -euo pipefail

if [ ! -f sfdx-project.json ]; then
  echo "Missing sfdx-project.json. Please create a Salesforce DX project first."
  exit 1
fi

if [ ! -f manifest/package.xml ]; then
  echo "Missing manifest/package.xml. Please add a deployment manifest."
  exit 1
fi

if ! command -v sf >/dev/null 2>&1; then
  echo "Salesforce CLI (sf) is not installed or not on PATH."
  exit 1
fi

if [ -z "${SF_USERNAME:-}" ] || [ -z "${SF_CONSUMER_KEY:-}" ] || [ -z "${SF_PRIVATE_KEY:-}" ]; then
  echo "Salesforce deployment environment variables are not set."
  echo "Required: SF_USERNAME, SF_CONSUMER_KEY, SF_PRIVATE_KEY"
  exit 1
fi

echo "${SF_PRIVATE_KEY}" > server.key
chmod 600 server.key

sf org login jwt \
  --username "${SF_USERNAME}" \
  --client-id "${SF_CONSUMER_KEY}" \
  --jwt-key-file server.key \
  --instance-url "${SF_LOGIN_URL:-https://login.salesforce.com}"

sf project deploy validate \
  --manifest manifest/package.xml \
  --target-org "${SF_USERNAME}" \
  --wait 10

rm -f server.key
