resource "google_storage_bucket" "bucket" {
  name     = "yt-demo-test-cloud-functions"
  location = var.region
}

resource "google_storage_bucket_object" "archive" {
  name   = "archive.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./src/archive.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = "hello_world"
  description = "My helloWorld function"
  runtime     = var.run_time

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = var.entry_point
  max_instances         = 5
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}