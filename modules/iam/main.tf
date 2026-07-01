resource "google_service_account" "ps_service_account" {
  for_each = var.service_accounts

  project      = var.project_id
  account_id   = each.value.account_id
  display_name = each.value.display_name
}

resource "google_project_iam_member" "sa_roles" {
  for_each = var.iam_binding

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.ps_service_account[each.value.service_account].email}"
}
