#!/bin/sh

set -ex

BASE_DIR=$(pwd)
DIRS=$(git --no-pager diff HEAD^..HEAD --name-only | xargs -I {} dirname {} | egrep -v "$EXCLUDE_DIRS" | uniq)
if [ -z "$DIRS" ]; then
  echo "No directories for apply."
  exit 0
fi

echo "Apply target directories: "
echo "$DIRS"

export CODEBUILD_SOURCE_VERSION=$(git log --merges --oneline --reverse --ancestry-path HEAD^..HEAD | grep 'Merge pull request #' | head -n 1 | cut -f5 -d' ' | sed 's/#/pr\//')
echo "CODEBUILD_SOURCE_VERSION: $CODEBUILD_SOURCE_VERSION"

for dir in $DIRS
do
  (cd "$dir" && terraform init -input=false -no-color)
  (cd "$dir" && terraform apply -input=false -no-color -auto-approve 2>&1 | /bin/tfnotify --config "$BASE_DIR"/.tfnotify.yml apply --message "$dir")
done