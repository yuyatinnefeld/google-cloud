# configure HTTP LB to balance traffic between the two backends

# 1 Create load balancer
# From Internet to my VMs or serverless services
# Name = http-lb

# 2 configure the backend
# 3 Create Backend Service
# name = http-backend
# Instance group = us-east1-mig
# port number = 80
# Balancing mode = Rate
# Maximum RPS = 50
# Capacity = 100

+

# name = http-backend
# Instance group = europe-west1-mig
# port number = 80
# Balancing mode = Rate
# Maximum RPS = 80
# Capacity = 100

# 4 create a health check
# name = http-health-check
# protocol = TCP
# port = 80

# 5 configure frontend
# protocol = HTTP
# IP version =IPv4
# IP Address = Eph
# Port = 80

+

# protocol = HTTP
# IP version =IPv6
# IP Address = Eph
# Port = 80
