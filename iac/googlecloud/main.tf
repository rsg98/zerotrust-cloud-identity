# main.tf

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

# Define the GCP Workforce Identity Pool Provider for Okta OIDC
resource "google_iam_workforce_pool_provider" "okta_oidc_provider" {
  # Required arguments
  workforce_pool_id = google_iam_workforce_pool.default.workforce_pool_id
  location          = google_iam_workforce_pool.default.location
  provider_id       = "okta-oidc-provider" # Choose a unique ID for this provider within the pool

  # Optional arguments
  display_name = "Okta OIDC Provider"
  description  = "OIDC provider for Okta authentication."
  disabled     = false # Set to true to disable this provider. Default is false.

  # OIDC specific configuration
  oidc {
    # Required: The OIDC issuer URI from your Okta application.
    # Example: "https://your-okta-domain.okta.com" or "https://your-okta-domain.okta.com/oauth2/default"
    # Replace YOUR_OKTA_DOMAIN with your actual Okta domain.
    issuer_uri = "https://YOUR_OKTA_DOMAIN.okta.com"

    # Required: The Client ID of the OIDC application configured in Okta.
    # Replace YOUR_OKTA_OIDC_CLIENT_ID with your actual client ID.
    client_id = "YOUR_OKTA_OIDC_CLIENT_ID"

    # Optional: Client secret for Authorization Code flow (recommended for web sign-in).
    # Store this securely, e.g., using Google Secret Manager or Terraform Cloud variables.
    # client_secret {
    #   value {
    #     plain_text = "YOUR_OKTA_OIDC_CLIENT_SECRET_VALUE" # Replace with your actual client secret
    #   }
    # }

    # Optional: Configuration for web single sign-on (SSO) for console access.
    # Requires client_secret to be configured if using 'CODE' flow.
    # web_sso_config {
    #   response_type                 = "CODE" # Or "ID_TOKEN" for implicit flow (less secure)
    #   assertion_claims_behavior   = "MERGE_USER_INFO_OVER_ID_TOKEN_CLAIMS" # Or "ONLY_ID_TOKEN_CLAIMS"
    #   additional_scopes           = ["groups", "email", "profile"] # Request additional scopes from Okta if needed
    # }

    # Optional: JWKS JSON string. If not set, it's fetched from the issuer_uri's .well-known endpoint.
    # jwks_json = file("path/to/your/okta_jwks.json")
  }

  # Attribute mapping: How claims from Okta tokens are mapped to Google attributes.
  # Ensure these attributes are included in the ID token from Okta.
  attribute_mapping = {
    # Required: Maps to the primary identifier for the user in GCP.
    # Typically, 'sub' (subject) claim from Okta (user's Okta ID or email).
    "google.subject" = "assertion.sub"

    # Optional: Maps to the user's display name in GCP console.
    # 'name' or 'preferred_username' are common Okta claims.
    "google.display_name" = "assertion.name"

    # Optional: Maps Okta groups to Google groups for IAM policies.
    # Requires Okta to be configured to include groups in the ID token.
    "google.groups" = "assertion.groups"

    # Optional: Custom attribute for user's email.
    # Useful for various GCP integrations.
    "attribute.email" = "assertion.email"

    # Optional: Custom attribute for department, if available in Okta claims.
    # "attribute.department" = "assertion.department"
  }

  # Optional: Attribute condition
  # A CEL expression to filter identities from this provider.
  # Example: "assertion.groups.contains('gcp-users')" to only allow users in the 'gcp-users' Okta group.
  # attribute_condition = "assertion.email.endsWith('@example.com')"

  depends_on = [
    google_iam_workforce_pool.default,
  ]
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

# Output the ID of the Workforce Pool Provider
output "workforce_pool_provider_id_output" {
  description = "The ID of the created workforce pool provider."
  value       = google_iam_workforce_pool_provider.okta_oidc_provider.provider_id
}

output "workforce_pool_provider_name_output" {
  description = "The resource name of the created workforce pool provider."
  value       = google_iam_workforce_pool_provider.okta_oidc_provider.name
}
