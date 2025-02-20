# Workload Identity Federation Implementation

This directory contains Terraform configurations to set up Workload Identity Federation (WIF) between GitHub Actions and Google Cloud Platform.

## Security Features

1. **Repository Naming Enforcement**: 
   - Only repositories under a specified GitHub organization/username can authenticate
   - Enforced through attribute conditions in the Workload Identity Provider
   - Example: If `allowed_repo_prefix = "myorg"`, only repositories like `myorg/repo1`, `myorg/repo2` can authenticate

## Components Created

1. **Workload Identity Pool**: A pool for external identities
2. **Workload Identity Provider**: GitHub-specific OIDC provider with repository restrictions
3. **Service Account**: Main service account for GitHub Actions authentication

## Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `project_id` | GCP Project ID | `my-project` |
| `project_number` | GCP Project Number | `123456789012` |
| `region` | GCP Region | `europe-west1` |
| `allowed_repo_prefix` | GitHub org/username allowed to use WIF | `myorg` |

## Setup Instructions

1. Create a `terraform.tfvars` file with your values:
   ```hcl
   project_id         = "your-project-id"
   project_number     = "123456789012"
   region            = "europe-west1"
   allowed_repo_prefix = "your-org"
   ```

2. Apply the Terraform configuration:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. Get the Workload Identity Provider name from the output:
   ```bash
   terraform output workload_identity_provider
   ```

4. Configure GitHub Actions:
   - Go to your repository settings
   - Under Security → Secrets and variables → Actions
   - Add these secrets:
     - `PROJECT_ID`: Your GCP project ID
     - `WIF_PROVIDER`: The Workload Identity Provider name from step 3

5. WIF impersonater 
   - Make sure the github-sa in wif project account as permissions to impersonate docker-sa, terraform-sa or cloudbuild-sa in the 
     project that you are meant to use.

## Usage in GitHub Actions

```yaml
jobs:
  deploy:
    # Repository must be under the allowed_repo_prefix organization/username
    permissions:
      contents: 'read'
      id-token: 'write'
    
    steps:
    - uses: 'google-github-actions/auth@v2'
      with:
        workload_identity_provider: '${{ secrets.WIF_PROVIDER }}'
        service_account: 'github-actions@${{ secrets.PROJECT_ID }}.iam.gserviceaccount.com'
```

## Security Considerations

1. Repository name restrictions ensure only authorized organizations can use WIF
2. Regular expressions validate the allowed prefix format
3. Authentication is based on GitHub's OIDC tokens
4. No static credentials are stored or needed

## Troubleshooting

1. Ensure your repository is under the allowed organization/username
2. Check the repository name matches the required prefix pattern
3. Verify the service account has necessary IAM roles
4. Check GitHub Actions logs for authentication errors
5. Ensure `id-token: write` permission is set in the workflow