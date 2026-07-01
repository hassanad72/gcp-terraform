# GCP Terraform

Terraform configuration for GCP environments using independent root modules
and shared infrastructure modules.

## Prerequisites

- Terraform 1.5 or newer
- Google Cloud CLI (`gcloud`)
- Go 1.26 or newer for Terratest
- An existing GCP project with billing and the required APIs enabled
- Permission to manage networking, firewall rules, service accounts, IAM, and storage
- Read and write access to the `pub-sap-bucket-tfstate` state bucket

Configure local Application Default Credentials before running Terraform:

```bash
gcloud auth application-default login
```

## Repository structure

```text
environments/
  dev/       Development root module and isolated remote state
  stage/     Reserved for the staging root module
  prod/      Reserved for the production root module
modules/
  firewall/  VPC firewall rules
  iam/       Service accounts and IAM memberships
  network/   VPC networks and subnets
  storage/   Cloud Storage buckets
```

The repository root is intentionally not a Terraform root. Run Terraform from
an environment directory so each environment uses the correct state and
variables.

## Development workflow

```bash
terraform -chdir=environments/dev init
terraform -chdir=environments/dev fmt -check -recursive
terraform -chdir=environments/dev validate
terraform -chdir=environments/dev plan
```

## Testing

Terratest creates real GCP resources and destroys them after the test. Use an
isolated test project rather than the development project.

```bash
cd environments/dev/test
go mod download
export TERRATEST_GCP_PROJECT="your-isolated-test-project"
go test -v -timeout 30m
```

Review every plan before applying it. Saved plans, local state, downloaded
providers, credentials, and local secret files must not be committed.
