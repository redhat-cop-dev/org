resource "github_team" "teams" {
  for_each = local.teams_config

  name           = each.key
  description    = each.value.description
  privacy        = each.value.privacy
  parent_team_id = try(each.value.parent, null) != null ? github_team.teams[each.value.parent].id : null
}

resource "github_team_members" "teams" {
  for_each = {
    for team_name, team in local.teams_config : team_name => team
    if length(try(team.maintainers, [])) > 0
  }

  team_slug = github_team.teams[each.key].slug

  dynamic "members" {
    for_each = each.value.maintainers
    content {
      username = members.value
      role     = "maintainer"
    }
  }
}

resource "github_team_repository" "teams" {
  for_each = local.team_repos

  team_id    = github_team.teams[each.value.team].id
  repository = each.value.repository
  permission = each.value.permission
}
