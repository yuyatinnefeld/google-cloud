resource "google_sql_database_instance" "public_db_instance" {
  name             = "public-db-instance"
  database_version = "POSTGRES_13"
  region           = var.region

  settings {
    tier = "db-custom-1-3840"
  }
  deletion_protection = false
}

resource "google_sql_database" "frontend_public_db" {
  name     = "frontend-db"
  instance = google_sql_database_instance.public_db_instance.name
}

resource "google_sql_user" "postgres_public_user" {
  name     = "postgres"
  instance = google_sql_database_instance.public_db_instance.name
  password = var.postgres_pass
  deletion_protection = false
}