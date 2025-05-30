# main.tf

# See public documentation at: https://cloud.google.com/iam/docs/workforce-sign-in-okta

# Configure the Google Cloud Provider
# Ensure you have authenticated with GCP and set your project appropriately,
# typically via gcloud CLI or environment variables.
provider "google" {
  # project = "your-gcp-project-id" # Optional: if not set by environment or gcloud config
  # region  = "your-gcp-region"     # Optional: if not set by environment or gcloud config
}

# Define the GCP Workforce Identity Pool
resource "google_iam_workforce_pool" "default" {
  # Required arguments
  parent              = "organizations/YOUR_ORGANIZATION_ID" # Replace YOUR_ORGANIZATION_ID with your actual organization ID (e.g., "123456789012")
  location            = "global"                             # Workforce pools are typically global
  workforce_pool_id   = "your-workforce-pool-id"             # Replace with a unique ID for your pool (e.g., "my-employee-pool")

  # Optional arguments
  display_name        = "My Example Workforce Pool"
  description         = "This is an example workforce pool managed by Terraform."
  session_duration    = "7200s"                              # Session duration for tokens issued by this pool (e.g., 2 hours = 7200s). Default is 3600s.
  disabled            = false                                # Set to true to disable the pool. Default is false.

  # Optional: Access Restrictions
  # access_restrictions {
  #   allowed_services {
  #     domain = "service_domain_to_allow_1" # e.g., "gcp.example.com"
  #   }
  #   allowed_services {
  #     domain = "service_domain_to_allow_2"
  #   }
  #   disable_programmatic_signin = false # Set to true to disable programmatic sign-in (e.g., via gcloud or APIs)
  # }

  #depends_on = [] # Add any explicit dependencies if needed
}

# Output the name of the workforce pool (useful for referencing in other resources or outputs)
output "workforce_pool_name" {
  description = "The resource name of the created workforce pool."
  value       = google_iam_workforce_pool.default.name
}

output "workforce_pool_id_output" {
  description = "The ID of the created workforce pool."
  value       = google_iam_workforce_pool.default.workforce_pool_id
}