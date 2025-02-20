variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region"
}

variable "impersonate_service_account" {
  type        = string
  description = "Service account email to impersonate"
}
