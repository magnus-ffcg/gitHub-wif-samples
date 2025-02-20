# Create a Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-pool"
  display_name             = "GitHub Actions Pool"
  description             = "Identity pool for GitHub Actions"
}

# Create a Workload Identity Pool Provider for GitHub
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions Provider"
  description                        = "OIDC identity pool provider for GitHub Actions"
  
  attribute_mapping = {
    "google.subject" = "assertion.sub",
    "attribattribute.repository" = "assertion.repositoryute"
  }
  
  attribute_condition = "assertion.repository.startsWith('${var.allowed_repo_prefix}/')"
  
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Create service accounts for different purposes
resource "google_service_account" "github_actions" {
  account_id   = "github-actions"
  display_name = "GitHub Actions Service Account"
  description  = "Service account for GitHub Actions authentication"
}

# Output the Workload Identity Provider name for GitHub Actions
output "workload_identity_provider" {
  description = "Workload Identity Provider to configure in GitHub Actions"
  value       = "projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.github_provider.workload_identity_pool_provider_id}"
}
