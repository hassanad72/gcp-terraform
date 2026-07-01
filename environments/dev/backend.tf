terraform {
  backend "gcs" {
    bucket = "pub-sap-bucket-tfstate"
    prefix = "environments/dev"
  }
}
