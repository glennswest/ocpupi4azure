#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if ! [ -x "$(command -v ./openshift-install)" ]; then
  echo "Error: openshift-install binary is required in $DIR. Aborting." >&2
  exit 1
fi

if ! [ -x "$(command -v az)" ]; then
  echo "Error: az (Azure CLI) is required in PATH. Aborting." >&2
  exit 1
fi

if ! [ -x "$(command -v python3)" ]; then
  echo "Error: python3 is required. Aborting." >&2
  exit 1
fi

if ! [ "$(pip list | grep -F dotmap)" ]; then
  echo "Error: python dotmap is required, please run 'pip install dotmap'. Aborting." >&2
  exit 1
fi

if ! [ -x "$(command -v jq)" ]; then
  echo "Error: jq binary is required in PATH. Aborting." >&2
  exit 1
fi

