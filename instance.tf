#Ist Instance Database
resource "aws_instance" "hasnain_database" {
  ami                    = "ami-096f43ef67d75e998"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.terraform_database.id}"]
  subnet_id              = aws_subnet.hasnain_private_1.id
  # vpc_security_group_ids      = ["${aws_security_group.terraform_database.id}"]
  # subnet_id                   = aws_subnet.hasnain_private_1.id
  tags = {
    Name = "hasnain_database"
  }
  user_data = <<EOF
    #!/bin/bash
      sudo su
      sudo yum install mariadb-server -y
      sudo systemctl start mariadb
      sudo systemctl enable mariadb
      sudo mysqladmin -u root password '${var.db_user_password}'
      sudo mysqladmin -uroot -p${var.db_user_password} create '${var.db_name}'
      sudo mysql -uroot -p${var.db_user_password} -e "CREATE USER '${var.dbusername}'@'%' IDENTIFIED BY '${var.db_user_password }';"
      sudo mysql -uroot -p${var.db_user_password} -e "GRANT ALL PRIVILEGES ON ${var.db_name}.* TO '${var.dbusername}'@'%';"
      sudo mysql -uroot -p${var.db_user_password} -e "FLUSH PRIVILEGES;"
    
EOF

  key_name  = "hasnainterraform"

}

output "instance_id_database" {
  description = "ID of the EC2 instance"
  value       = aws_instance.hasnain_database.id
}

output "instance_ip_addr" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.hasnain_database.private_ip
}

# 2nd Instance Web
# resource "aws_instance" "web-node" {
#   ami                         = "ami-096f43ef67d75e998"
#   instance_type               = "t2.micro"
#   vpc_security_group_ids      = ["${aws_security_group.wordpress.id}"]
#   subnet_id                   = aws_subnet.hasnain-public_1.id
#   associate_public_ip_address = true
#   depends_on                  = [aws_instance.hasnain_database]
#   tags = {
#     Name = "web-node"
#   }
#   user_data = <<EOF
# 		#!/bin/bash
#         yum install httpd php php-mysql -y
#         cd /var/www/html
#         wget https://wordpress.org/wordpress-5.1.1.tar.gz
#         tar -xzf wordpress-5.1.1.tar.gz
#         cp -r wordpress/* /var/www/html/
#         rm -rf wordpress
#         rm -rf wordpress-5.1.1.tar.gz
#         chmod -R 755 wp-content
#         chown -R apache:apache wp-content
#         chkconfig httpd on
#         sudo service httpd restart
#         cd /var/www/html    
#         cp wp-config-sample.php wp-config.php
#         sed -i "s/database_name_here/${var.db_name}/g" wp-config.php
#         sed -i "s/username_here/${var.dbusername}/g" wp-config.php
#         sed -i "s/password_here/${var.db_user_password}/g" wp-config.php
#         sed -i "s/localhost/${aws_instance.hasnain_database.private_ip}/g" wp-config.php
#         cat <<EOF >>/var/www/html/wp-config.php 
        
# EOF


#   key_name = "hasnainterraform"

#   connection {
#     user        = "ec2-user"
#     private_key = file("${var.private_key_path}")
#     host        = aws_instance.web-node.public_ip
#   }
# }
# output "instance_id" {
#   description = "ID of the EC2 instance"
#   value       = aws_instance.web-node.id
# }

# output "instance_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.web-node.public_ip
# }


