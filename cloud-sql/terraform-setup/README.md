## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allow_http](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_https](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_ssh](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/compute_firewall) | resource |
| [google_compute_global_address.private_ip_address](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/compute_global_address) | resource |
| [google_compute_network.main_net](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.subnet_0](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/compute_subnetwork) | resource |
| [google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/service_networking_connection) | resource |
| [google_sql_database.frontend_private_db](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/sql_database) | resource |
| [google_sql_database.frontend_public_db](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/sql_database) | resource |
| [google_sql_database_instance.private_db_instance](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/sql_database_instance) | resource |
| [google_sql_database_instance.public_db_instance](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/sql_database_instance) | resource |
| [google_sql_user.postgres_private_user](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/sql_user) | resource |
| [google_sql_user.postgres_public_user](https://registry.terraform.io/providers/hashicorp/google/4.0.0/docs/resources/sql_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_frontend_user_pass"></a> [frontend\_user\_pass](#input\_frontend\_user\_pass) | n/a | `string` | `"frontend_user"` | no |
| <a name="input_postgres_pass"></a> [postgres\_pass](#input\_postgres\_pass) | n/a | `string` | `"postgres"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | `"yt-demo-dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"europe-west1"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | `"europe-west1b"` | no |

## Outputs

No outputs.
