locals {
  org_config     = yamldecode(file("${path.module}/../data/org.yaml"))
  members_config = yamldecode(file("${path.module}/../data/members.yaml"))
  repos_config   = yamldecode(file("${path.module}/../data/repos.yaml")).repos
  teams_config   = yamldecode(file("${path.module}/../data/teams.yaml")).teams

  memberships = merge(
    { for username in local.members_config.admins : username => "admin" },
    { for username in local.members_config.members : username => "member" },
  )

  team_repos = {
    for entry in flatten([
      for team_name, team in local.teams_config : [
        for repo_name, permission in try(team.repos, {}) : {
          key        = "${team_name}:${repo_name}"
          team       = team_name
          repository = repo_name
          permission = permission
        }
      ]
    ]) : entry.key => entry
  }
}
