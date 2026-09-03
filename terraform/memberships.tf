resource "github_membership" "members" {
  for_each = local.memberships

  username = each.key
  role     = each.value
}
