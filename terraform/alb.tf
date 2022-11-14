resource "aws_lb" "github-actions-alb" {
  name               = "github-actions-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.github-actions-alb-sg.id]
  subnets            = var.subnets
}

resource "aws_lb_target_group" "github-actions-tg" {
  name                  = "github-actions-tg"
  port                  = var.container_port
  protocol              = "HTTP"
  target_type           = "ip"
  vpc_id                = var.vpc_id
  deregistration_delay  = 20
}

resource "aws_lb_listener" "tls-lstnr" {
  load_balancer_arn = aws_lb.github-actions-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.radazen-cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.github-actions-tg.arn
  }
}

resource "aws_lb_listener" "http-lstnr" {
  load_balancer_arn = aws_lb.github-actions-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.github-actions-tg.arn
  }
}