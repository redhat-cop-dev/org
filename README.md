# Red Hat Community of Practice Development GitHub Organization

This repository contains the metadata configuration for the Red Hat Community of Practice Development GitHub organization. Configuration is managed with [Terraform](https://www.terraform.io/) using the [integrations/github](https://registry.terraform.io/providers/integrations/github/latest) provider.

## Repository layout

```
data/
  org.yaml       # Organization settings
  members.yaml   # Org admins and members
  repos.yaml     # Organization repositories
  teams.yaml     # Teams, maintainers, and repository permissions
terraform/       # Terraform configuration (loads data/*.yaml)
scripts/
  import.sh      # One-time import script for Peribolos migration
```

## Making changes

1. Edit the YAML files under `data/`.
2. Open a pull request — the Terraform workflow runs `terraform plan` and posts the output as a PR comment.
3. Merge to `main` — the workflow runs `terraform apply` automatically.

### Adding a member

Add the username to `data/members.yaml` under `admins` or `members`.

### Adding a team

Add an entry to `data/teams.yaml` under `teams`. For nested teams, set a `parent` field to the parent team name.

### Adding a repository

Add an entry to `data/repos.yaml` under `repos` with a `visibility` of `public` or `private`. Terraform manages repo existence and visibility only; repo admins control all other settings (description, wiki, merge options, branch protection, etc.) in the GitHub UI.

### Granting team repository access

Under the team entry in `data/teams.yaml`, add repos with permission levels (`pull`, `triage`, `push`, `maintain`, or `admin`). The Peribolos `read` permission maps to `pull`.

## Required secrets and variables

Configure these in the GitHub repository settings before the workflow can run:

| Name | Type | Description |
|------|------|-------------|
| `GH_ORG_ADMIN_TOKEN` | Secret | PAT with `admin:org`, `repo`, and `read:org` scopes (rename from former `PERIBOLOS_TOKEN`) |
| `ORG_BILLING_EMAIL` | Secret | Organization billing email address |
| `TF_API_TOKEN` | Secret | Terraform Cloud API token |
| `TF_CLOUD_ORGANIZATION` | Variable | Terraform Cloud organization name |
| `TF_WORKSPACE` | Variable | Terraform Cloud workspace name |

## Local development

```bash
export TF_VAR_github_token="ghp_..."
export TF_VAR_billing_email="billing@example.com"
export TF_CLOUD_ORGANIZATION="your-tfc-org"
export TF_WORKSPACE="dev-org-redhat-cop-dev"

cd terraform
terraform init
terraform plan
```

## Migrating from Peribolos

If this org was previously managed by Peribolos, run the one-time import script to adopt existing resources into Terraform state:

```bash
export TF_VAR_github_token="ghp_..."
export TF_VAR_billing_email="billing@example.com"
export TF_CLOUD_ORGANIZATION="your-tfc-org"
export TF_WORKSPACE="dev-org-redhat-cop-dev"

cd terraform
terraform init
../scripts/import.sh
terraform plan
```

The import script adopts the current `redhat-cop-dev` org resources (settings, members, repositories, teams, and team-repo bindings) into Terraform state.

## Drift detection

A scheduled workflow runs nightly at 03:00 UTC and produces a plan artifact. Review the artifact for unexpected drift from manual GitHub UI changes.
