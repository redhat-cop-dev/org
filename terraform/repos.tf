resource "github_repository" "repos" {
  for_each = local.repos_config

  name       = each.key
  visibility = each.value.visibility

  lifecycle {
    ignore_changes = [
      description,
      has_issues,
      has_projects,
      has_wiki,
      allow_merge_commit,
      allow_squash_merge,
      allow_rebase_merge,
      delete_branch_on_merge,
    ]
  }
}
