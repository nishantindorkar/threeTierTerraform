# Define the ALB and target group
resource "aws_lb" "nginx_lb" {
  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  security_groups    = [aws_security_group.main-sg.id]

  tags = {
    Name = "nginx-alb"
  }
}

resource "aws_lb_target_group" "nginx_tg" {
  name_prefix = "ng-tg-"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main-vpc.id

  health_check {
    path     = "/"
    protocol = "HTTP"
    matcher  = "200"
  }
}

resource "aws_lb_target_group_attachment" "nginx_register_targets" {
  count            = 2
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = count.index < 2 ? aws_instance.private_instances[count.index].id : null
  port             = 80
}


# Attach the target group to the ALB
resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.nginx_tg.arn
    type             = "forward"
  }
}


########## ----- for tomcat (internal) ------ ##########

resource "aws_lb" "internal_alb" {
  name               = "tomcat-internal-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  security_groups    = [aws_security_group.main-sg.id]

  tags = {
    Name = "tomcat-internal-alb"
  }
}

resource "aws_lb_listener" "internal_alb_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_alb_tg.arn
  }
}

resource "aws_lb_target_group" "internal_alb_tg" {
  name     = "internal-alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main-vpc.id

  health_check {
    path     = "/"
    interval = 30
  }
}

resource "aws_lb_target_group_attachment" "internal_alb_register_targets" {
  target_group_arn = aws_lb_target_group.internal_alb_tg.arn
  count            = 2
  target_id        = aws_instance.private_instances[count.index + 2].id
}
