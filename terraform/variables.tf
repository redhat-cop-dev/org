variable "github_owner" {
  description = "GitHub organization name"
  type        = string
  default     = "redhat-cop-dev"
}

variable "github_token" {
  description = "GitHub PAT with admin:org, repo, and read:org scopes"
  type        = string
  sensitive   = true
}

variable "billing_email" {
  description = "Organization billing email address"
  type        = string
  sensitive   = true
}
