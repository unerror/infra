resource "digitalocean_spaces_bucket" "signoz-storage" {
  name   = "unenet-signoz-storage"
  region = "nyc3"
  lifecycle_rule {
    id                                     = "delete-objects-after-30-days"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 1
    expiration {
      days = 30
    }
    noncurrent_version_expiration {
      days = 5
    }
  }
  versioning {
    enabled = true
  }
  acl = "private"
}
