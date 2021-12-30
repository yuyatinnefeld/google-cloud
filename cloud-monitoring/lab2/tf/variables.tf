variable "project_id" {
  default = "yt-demo-test"
}

variable "region" {
  default = "europe-west1"
}
variable "zone" {
  default = "europe-west1-b"
}

### CLOUD FUNCTIONS SETUP
variable "run_time" {
  default =  "python37"
}

variable "entry_point" {
  default = "hello_world"
}