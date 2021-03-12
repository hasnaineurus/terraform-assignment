resource "aws_launch_configuration" "hasnain-launchconfig" {
  name_prefix                 = "hasnain-launchconfig"
  image_id                    = "${var.AMIS}"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  depends_on                  = [aws_instance.hasnain_database]
  key_name                    = "hasnainterraform"
  security_groups             = [aws_security_group.wordpress.id]
  user_data = <<EOF
		#!/bin/bash
        yum install httpd php php-mysql -y
        cd /var/www/html
        wget https://wordpress.org/wordpress-5.1.1.tar.gz
        tar -xzf wordpress-5.1.1.tar.gz
        cp -r wordpress/* /var/www/html/
        rm -rf wordpress
        rm -rf wordpress-5.1.1.tar.gz
        chmod -R 755 wp-content
        chown -R apache:apache wp-content
        chkconfig httpd on
        sudo service httpd restart
        cd /var/www/html    
        cp wp-config-sample.php wp-config.php
        sed -i "s/database_name_here/${var.db_name}/g" wp-config.php
        sed -i "s/username_here/${var.dbusername}/g" wp-config.php
        sed -i "s/password_here/${var.db_user_password}/g" wp-config.php
        sed -i "s/localhost/${aws_instance.hasnain_database.private_ip}/g" wp-config.php
        cat <<EOF >>/var/www/html/wp-config.php 

EOF

}

resource "aws_autoscaling_group" "hasnain-autoscaling" {
  name                      = "hasnain-autoscaling"
  vpc_zone_identifier       = [aws_subnet.hasnain-public_1.id, aws_subnet.hasnain-public_2.id]
  launch_configuration      = aws_launch_configuration.hasnain-launchconfig.name
  min_size                  = 1
  max_size                  = 2
  desired_capacity = 1
  wait_for_capacity_timeout = 0
  health_check_grace_period = 20
  health_check_type         = "EC2"

  #   target_group_arns         = "aws_alb_target_group.frontend-wordpress.arn"
  tag {
    key                 = "Name"
    value               = "ec2-instance-hasnain"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.hasnain-autoscaling.id
  alb_target_group_arn   = aws_alb_target_group.frontend-wordpress.arn
}
