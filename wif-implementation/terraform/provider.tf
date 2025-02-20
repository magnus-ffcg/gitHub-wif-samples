terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {}
}

provider "google" {
  alias = "impersonation"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "default" {
  provider               	= google.impersonation
  target_service_account 	= var.impersonate_service_account
  scopes                 	= [
    "userinfo-email", 
    "cloud-platform"
  ]
  lifetime               	= "1200s"
}

provider "google" {
  project = var.project_id
  region  = var.region
  access_token = data.google_service_account_access_token.default.access_token
  request_timeout = "60s"
}