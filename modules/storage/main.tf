resource "google_storage_bucket" "PS_bucket" {
  for_each = var.buckets

  name          = each.value.name
  location      = each.value.location
  storage_class = each.value.storage_class

  uniform_bucket_level_access = each.value.uniform_bucket_level_access
  public_access_prevention    = each.value.public_access_prevention

  versioning {
    enabled = each.value.versioning_enabled
  }

  force_destroy = each.value.force_destroy
}

resource "google_storage_bucket_iam_member" "members" {
  for_each = var.bucket_iam_members

  bucket = google_storage_bucket.PS_bucket[each.value.bucket_key].name
  role   = each.value.role
  member = each.value.member
}
