variable "project_id" {
  default = "yt-demo-test"
}

variable "region" {
  default = "europe-west1"
}
variable "zone" {
  default = "europe-west1-b"
}

### GCE SETUP
variable "vm_name" {
  default =  "lamp-1-vm"
}

variable "machine_type" {
  default = "n1-standard-2"
}