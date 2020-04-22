provider "cloudflare" {
  version = "~> 2.0"
}

variable "zone" {
}

resource "cloudflare_record" "dynamoosejs_com" {
  zone_id = var.zone
  name    = "dynamoosejs.com"
  value   = "dynamoosejs.com.s3-website-us-west-2.amazonaws.com"
  type    = "CNAME"
  ttl     = "1"
  proxied = true
}
