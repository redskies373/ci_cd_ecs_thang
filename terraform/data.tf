data "aws_acm_certificate" "radazen-cert" {
  domain   = "www.radazen.com"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "radazen" {
  zone_id   = var.dns_zone_id
}

data aws_caller_identity current {}