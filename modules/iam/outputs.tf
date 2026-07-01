output "service_account_emails" {
  value = {
    for key, sa in google_service_account.ps_service_account :
    key => sa.email
  }
}

output "service_accounts_id" {
  value = {
    for key, sa in google_service_account.ps_service_account :
    key => sa.id
  }
}