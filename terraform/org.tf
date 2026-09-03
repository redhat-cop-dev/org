resource "github_organization_settings" "org" {
  billing_email                           = var.billing_email
  company                                 = local.org_config.company
  default_repository_permission           = local.org_config.default_repository_permission
  description                             = local.org_config.description
  email                                   = local.org_config.email
  has_organization_projects               = local.org_config.has_organization_projects
  has_repository_projects                 = local.org_config.has_repository_projects
  location                                = local.org_config.location
  members_can_create_repositories         = local.org_config.members_can_create_repositories
  members_can_create_public_repositories  = local.org_config.members_can_create_public_repositories
  members_can_create_private_repositories = local.org_config.members_can_create_private_repositories
  members_can_create_pages                = local.org_config.members_can_create_pages
  members_can_create_public_pages         = local.org_config.members_can_create_public_pages
  members_can_create_private_pages        = local.org_config.members_can_create_private_pages
  members_can_fork_private_repositories   = local.org_config.members_can_fork_private_repositories
  web_commit_signoff_required             = local.org_config.web_commit_signoff_required
  name                                    = local.org_config.name
}
