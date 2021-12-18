#resource "google_compute_instance" "demo-vm-instance" {
#  name         = "demo-vm-instance"
#  machine_type = "f1-micro"
#  tags         = ["demo-vm-instance"]
#  boot_disk {
#    initialize_params {
#      image = "debian-cloud/debian-9"
#    }
#  }
#   metadata = {
#     ssh-keys = "demouser:${file("./demouser.pub")}"
#   }

#   network_interface {
#     network = google_compute_network.main_net.name
#     access_config {
#     }
#   }
# }