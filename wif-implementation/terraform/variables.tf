variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "project_number" {
  type        = string
  description = "The GCP project number"
}

variable "region" {
  type        = string
  description = "The GCP region"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository in format: OWNER/REPOSITORY"
}

variable "impersonate_service_account" {
  type        = string
  description = "Service account email to impersonate"
}

variable "allowed_repo_prefix" {
  type        = string
  description = "GitHub organization or username that is allowed to use Workload Identity Federation. Only repositories under this prefix will be allowed to authenticate."
  
  validation {
    condition     = can(regex("^my-prefix-.+$", var.allowed_repo_prefix))
    error_message = "The allowed_repo_prefix must start with my-prefix-"
  }
}
