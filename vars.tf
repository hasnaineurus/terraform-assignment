variable "AWS_ACCESS_KEY" {}
variable "AWS_SECERT_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-1"
}
variable "AMIS" {
  default = "ami-096f43ef67d75e998"
}
variable "private_key_path" {
  default = "hasnainterraform.pem"
}
 variable "dbusername" {
  type    = string
  default = "wpadmin"
}
variable "db_user_password" {
  type    = string
  default = "newpassword"
}
variable "db_name" {
  type    = string
  default = "wordpress"
}

   
# variable "ip_db_instance"{

  
# }
