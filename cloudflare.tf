variable "zone" {}

resource "cloudflare_record" "test_dynamoosejs_com" {
  zone_id = var.zone
  name    = "test.dynamoosejs.com"
  value   = "HelloWorld"
  type    = "TXT"
  ttl     = "1"
  proxied = true
}

resource "cloudflare_record" "dynamoosejs_com" {
  zone_id = var.zone
  name    = "dynamoosejs.com"
  value   = "dynamoosejs.com.s3-website-us-west-2.amazonaws.com"
  type    = "CNAME"
  ttl     = "1"
  proxied = true
}

resource "cloudflare_record" "alpha_dynamoosejs_com" {
  zone_id = var.zone
  name    = "alpha.dynamoosejs.com"
  value   = "alpha.dynamoosejs.com.s3-website-us-west-2.amazonaws.com"
  type    = "CNAME"
  ttl     = "1"
  proxied = true
}

resource "cloudflare_record" "beta_dynamoosejs_com" {
  zone_id = var.zone
  name    = "beta.dynamoosejs.com"
  value   = "beta.dynamoosejs.com.s3-website-us-west-2.amazonaws.com"
  type    = "CNAME"
  ttl     = "1"
  proxied = true
}

resource "cloudflare_record" "v1_dynamoosejs_com" {
  zone_id = var.zone
  name    = "v1.dynamoosejs.com"
  value   = "v1.dynamoosejs.com.s3-website-us-west-2.amazonaws.com"
  type    = "CNAME"
  ttl     = "1"
  proxied = true
}

resource "cloudflare_record" "v2_dynamoosejs_com" {
  zone_id = var.zone
  name    = "v2.dynamoosejs.com"
  value   = "v2.dynamoosejs.com.s3-website-us-west-2.amazonaws.com"
  type    = "CNAME"
  ttl     = "1"
  proxied = true
}
