#!/bin/sh

set -ex

BASE_DIR=$(pwd)
DIRS=$(git --no-pager diff master..HEAD --name-only | xargs -I {} dirname {} | egrep -v "$EXCLUDE_DIRS" | uniq)
if [ -z "$DIRS" ]; then
  echo "No directories for plan."
  exit 0
fi

echo "Plan target directories: "
echo "$DIRS"

for dir in $DIRS
do
  (cd "$dir" && terraform init -input=false -no-color)
  (cd "$dir" && terraform plan -input=false -no-color 2>&1 | /bin/tfnotify --config "$BASE_DIR"/.tfnotify.yml plan --message "$dir")
done