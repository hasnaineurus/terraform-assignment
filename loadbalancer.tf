resource "aws_alb" "hasnain-alb" {
  name                       = "hasnain-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [aws_subnet.hasnain-public_1.id, aws_subnet.hasnain-public_2.id]
  security_groups            = [aws_security_group.wordpress.id]
  enable_deletion_protection = false
  tags = {
    Name = "hasnain-alb"
  }
}

resource "aws_alb_target_group" "frontend-wordpress" {
  name     = "frontend-wordpress"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.hasnain_vpc.id
  
}


resource "aws_alb_listener" "frontend-listner-80" {
  load_balancer_arn = aws_alb.hasnain-alb.arn
  port              = 80

  default_action {
    target_group_arn = aws_alb_target_group.frontend-wordpress.arn
    type             = "forward"
  }
# ssl_policy = "value"
#   certificate_arn = ""

}


# resource "aws_alb_listener" "frontend-listner-8080" {
#   default_action {
#     target_group_arn = ""
#     type = "forward"
#   }
#   load_balancer_arn = aws_lb.albhasnain.arn
#   port = 8080
# }
# resource "aws_alb_listener" "frontend-listner-443" {
#   default_action {
#     target_group_arn = ""
#     type = "forward"
#   }
#   load_balancer_arn = aws_lb.albhasnain.arn
#   port = 443
#   protocol = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn = ""
# }
