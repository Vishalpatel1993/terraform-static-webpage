# SSL Certificate
resource "aws_acm_certificate" "ssl_certificate" {
  provider                  = aws.acm_provider
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  #validation_method         = "EMAIL"
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

#comment the validation_record_fqdns line if you do DNS validation instead of Email.
resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.acm_provider
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

#IMPORTANT - if the first time running this for a domian - the terraform script will not complete until the domain has  been validated. Validation can take some time ( roughly 30 minutes)
#DNS validation requires the domain nameservers to already be pointing to AWS. However, you won’t know the nameservers you need until after the NS Route 53 record has been created.
