resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.radazen.id
  name    = "www.${data.aws_route53_zone.radazen.name}"
  type    = "A"

  alias {
    name                   = aws_lb.github-actions-alb.dns_name
    zone_id                = aws_lb.github-actions-alb.zone_id
    evaluate_target_health = true
  }
}