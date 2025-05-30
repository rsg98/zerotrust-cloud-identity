# GDS Hackathon

## Level 1

Use [Workforce Identity](https://cloud.google.com/iam/docs/workforce-identity-federation) to use identities from a third party IdP to login directly to Google Cloud console, without requiring a sync of identities.

### Workforce Identity Pool using Okta as an identity provider (IdP)

1. Create the Okta Client Application following steps here: https://cloud.google.com/iam/docs/workforce-sign-in-okta#create-provider (using OIDC)
2. Update main.tfvars with your configuration details
3. Apply terraform

```
terraform init
terraform apply -var-file='main.tfvars'
```
4. The sign-in URL is provided as an output variable from Terraform

