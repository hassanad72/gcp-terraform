output "bucket_names" {
  value = {
    for key, bucket in google_storage_bucket.PS_bucket : key => bucket.name
  }
}

output "bucket_urls" {
  value = {
    for key, bucket in google_storage_bucket.PS_bucket : key => bucket.url
  }
}