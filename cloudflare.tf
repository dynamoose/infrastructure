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

resource "cloudflare_record" "tmptextrecord_dynamoosejs_com" {
  zone_id = var.zone
  name    = "tmptextrecord.dynamoosejs.com"
  value   = "helloworld"
  type    = "TXT"
  ttl     = 1
  proxied = false
}
