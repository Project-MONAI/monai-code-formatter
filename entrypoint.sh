#!/bin/bash

format_args=$1
bot_email=$2
bot_username=$3
message=$4
token=$5

if ! git status > /dev/null 2>&1
then
  echo "In case of any errors, please consider having actions/checkout before this workflow step."
  git init
fi

if [[ -z "$GITHUB_HEAD_REF" ]]; then
  echo "Unknown source branch of the pull request."
  exit 0
fi

set -o xtrace
PR_NUMBER=$(jq -r ".pull_request.number" "$GITHUB_EVENT_PATH")
URI=https://api.github.com
API_HEADER="Accept: application/vnd.github.v3+json"
# AUTH_HEADER="Authorization: token $token"
# pr_resp=$(curl -X GET -s -H "${API_HEADER}" -H "${AUTH_HEADER}" "${URI}/repos/$GITHUB_REPOSITORY/pulls/$PR_NUMBER")
pr_resp=$(curl -X GET -s -H "${API_HEADER}" "${URI}/repos/$GITHUB_REPOSITORY/pulls/$PR_NUMBER")
HEAD_REPO=$(echo "$pr_resp" | jq -r .head.repo.full_name)
HEAD_BRANCH=$(echo "$pr_resp" | jq -r .head.ref)

if [[ "$HEAD_REPO" == "null" ]]; then
  echo "Unknown source repo"
  exit 0
fi

if [[ "$HEAD_BRANCH" == "null" ]]; then
  echo "Unknown source branch"
  exit 0
fi

git remote add fork https://x-access-token:"$token"@github.com/"$HEAD_REPO".git
git fetch fork "$HEAD_BRANCH"
git checkout -b "$HEAD_BRANCH" fork/"$HEAD_BRANCH"

git config --global user.email "$bot_email"
git config --global user.name "$bot_username"

bash -c "black $format_args"

git add .
git commit -m "$message" || true

git push --force-with-lease fork "$HEAD_BRANCH"
