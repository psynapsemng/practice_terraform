# practice_terraform lab 2

# terraform graph

digraph {
        compound = "true"
        newrank = "true"
        subgraph "root" {
                "[root] aws_instance.web_server (expand)" [label = "aws_instance.web_server", shape = "box"]
#instance AWS
                "[root] aws_security_group.instance (expand)" [label = "aws_security_group.instance", shape = "box"]
#security gourp AWS 
                "[root] provider[\"registry.terraform.io/hashicorp/aws\"]" [label = "provider[\"registry.terraform.io/hashicorp/aws\"]", shape = "diamond"] 
#fournisseur AWS 
                "[root] var.security_group_name" [label = "var.security_group_name", shape = "note"]
#variable de nom de security group
                "[root] aws_instance.web_server (expand)" -> "[root] aws_security_group.instance (expand)"
                "[root] aws_security_group.instance (expand)" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"]"
                "[root] aws_security_group.instance (expand)" -> "[root] var.security_group_name"
                "[root] output.public-ip (expand)" -> "[root] aws_instance.web_server (expand)" 
#La sortie graphique indique également que l'adresse IP publique (output.public-ip) dépend de l'instance AWS.

                "[root] provider[\"registry.terraform.io/hashicorp/aws\"] (close)" -> "[root] aws_instance.web_server (expand)"
                "[root] root" -> "[root] output.public-ip (expand)"
                "[root] root" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"] (close)"
        }
}
![image](https://user-images.githubusercontent.com/78550822/217252884-a1920f35-1ccb-4bf3-94b7-4404873c26fa.png)

Les lignes suivantes décrivent la ressource que Terraform va créer, une instance AWS EC2, identifiée comme « aws_instance.web_server ». Les propriétés de l'instance sont répertoriées, y compris l'Amazon Machine Image (AMI) qui sera utilisée pour lancer l'instance (ami-06cc80fe7e768f974), le type d'instance (t2.micro), la balise de nom de l'instance (WebServerInstance) .

Certaines des propriétés sont indiquées comme "(connu après application)", ce qui signifie que leurs valeurs seront déterminées après la création de l'instance et que Terraform a collecté des informations à son sujet.


# terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:      

  + create

Terraform will perform the following actions:

  # aws_instance.web_server will be created
  + resource "aws_instance" "web_server" {
      + ami                                  = "ami-06cc80fe7e768f974"
 # Image Id de la région définis
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro" 
# Type d'instance définis
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "WebServerInstance"
        }
      + tags_all                             = {
          + "Name" = "WebServerInstance"
        }
      + tenancy                              = (known after apply)
      + user_data                            = "c765373c563b260626d113c4a56a46e8a8c5ca33"
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = true 
# User data replace égale à True
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id                 = (known after apply)
              + capacity_reservation_resource_group_arn = (known after apply)
            }
        }

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + maintenance_options {
          + auto_recovery = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
          + instance_metadata_tags      = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_card_index    = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + private_dns_name_options {
          + enable_resource_name_dns_a_record    = (known after apply)
          + enable_resource_name_dns_aaaa_record = (known after apply)
          + hostname_type                        = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_security_group.instance will be created
  + resource "aws_security_group" "instance" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0", 
                ] #Ajout du bloque cidr Block
              + description      = ""
              + from_port        = 8080 #Port 8080 ouvert
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp" #Protocol définis
              + security_groups  = []
              + self             = false
              + to_port          = 8080 #Port 8080 ouvert
            },
        ]
      + name                   = "terraform-exemple-instance"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + public-ip = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Enter a value: yes

aws_security_group.instance: Creating...
aws_security_group.instance: Creation complete after 2s [id=sg-0c72ac6ab67345f36]
aws_instance.web_server: Creating...
aws_instance.web_server: Still creating... [10s elapsed]
aws_instance.web_server: Still creating... [20s elapsed]
aws_instance.web_server: Still creating... [30s elapsed]
aws_instance.web_server: Still creating... [40s elapsed]
aws_instance.web_server: Creation complete after 42s [id=i-0e950668a50b7ebd3]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

public-ip = "35.181.152.155"
