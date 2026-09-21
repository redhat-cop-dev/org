#!/usr/bin/env bash
# One-time import script for migrating from Peribolos-managed state to Terraform.
# Prerequisites:
#   - terraform init (with TFC or local backend configured)
#   - TF_VAR_github_token or github_token variable set
#   - TF_CLOUD_ORGANIZATION and TF_WORKSPACE set (if using Terraform Cloud)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="${SCRIPT_DIR}/../terraform"
ORG="redhat-cop-dev"

cd "${TERRAFORM_DIR}"

echo "Importing organization settings..."
terraform import github_organization_settings.org 54118285

ADMINS=(
  djdanielsson
  garethahealy
  pabrahamsson
  sabre1041
)
MEMBERS=(
  etsauer
)

for username in "${ADMINS[@]}" "${MEMBERS[@]}"; do
  echo "Importing membership: ${username}"
  terraform import "github_membership.members[\"${username}\"]" "${ORG}:${username}"
done

REPOS=(
  org
  test-repo
  github-actions-ssh
  member-mapping
)

for repo in "${REPOS[@]}"; do
  echo "Importing repository: ${repo}"
  terraform import "github_repository.repos[\"${repo}\"]" "${repo}"
done

TEAMS=(
  test
  test-team1
  test-team1-subteam1
)

for team in "${TEAMS[@]}"; do
  echo "Importing team: ${team}"
  terraform import "github_team.teams[\"${team}\"]" "${ORG}:${team}"
  echo "Importing team members: ${team}"
  terraform import "github_team_members.teams[\"${team}\"]" "${team}"
done

TEAM_REPOS=(
  "test-team1:test-repo"
  "test-team1-subteam1:test-repo"
)

for entry in "${TEAM_REPOS[@]}"; do
  team="${entry%%:*}"
  repo="${entry##*:}"
  echo "Importing team repository: ${team}/${repo}"
  terraform import "github_team_repository.teams[\"${team}:${repo}\"]" "${team}:${repo}"
done

echo ""
echo "Import complete. Run 'terraform plan' to verify zero or minimal drift."
