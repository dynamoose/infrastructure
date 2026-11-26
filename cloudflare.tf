variable "zone" {}

variable "pages_apex" {
  description = "rrainn Pages apex hostname, ownership proof, certificate delegation and cutover state."
  type = object({
    hostname          = string
    ownership_value   = string
    certificate_cname = optional(string)
    cutover           = optional(bool, false)
  })
  default = null

  validation {
    condition = var.pages_apex == null ? true : (
      can(regex("^[a-z0-9-]+[.]pages[.]cloud[.]rrainn[.]com$", var.pages_apex.hostname)) &&
      try(trimspace(var.pages_apex.ownership_value) != "", false) &&
      (!var.pages_apex.cutover || try(trimspace(var.pages_apex.certificate_cname) != "", false))
    )
    error_message = "Set the generated Pages hostname and ownership TXT value. Cutover also requires the Pages certificate CNAME target."
  }
}

locals {
  pages_apex_cutover = var.pages_apex == null ? false : var.pages_apex.cutover
}

# Ownership and certificate validation can converge while CloudFront still serves the apex.
resource "cloudflare_record" "dynamoosejs_com_pages_ownership" {
  count   = var.pages_apex == null ? 0 : 1
  zone_id = var.zone
  name    = "_rrainn-pages.dynamoosejs.com"
  value   = var.pages_apex.ownership_value
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_record" "dynamoosejs_com_pages_certificate" {
  count   = try(trimspace(var.pages_apex.certificate_cname) != "", false) ? 1 : 0
  zone_id = var.zone
  name    = "_acme-challenge.dynamoosejs.com"
  value   = var.pages_apex.certificate_cname
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "dynamoosejs_com" {
  zone_id = var.zone
  name    = "dynamoosejs.com"
  value   = local.pages_apex_cutover ? var.pages_apex.hostname : "dmz8ymrutkf3e.cloudfront.net"
  type    = "CNAME"
  ttl     = "1"
  # DNS-only flattening sends clients directly to Pages for HTTPS.
  proxied = !local.pages_apex_cutover
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

resource "cloudflare_record" "v3_dynamoosejs_com" {
  zone_id = var.zone
  name    = "v3.dynamoosejs.com"
  value   = "v3.dynamoosejs.com.s3-website-us-west-2.amazonaws.com"
  type    = "CNAME"
  ttl     = "1"
  proxied = true
}

resource "cloudflare_record" "_atproto_dynamoosejs_com" {
  zone_id = var.zone
  name    = "_atproto.dynamoosejs.com"
  value   = "did=did:plc:nhvwjobckl3vhjj5tebcthbz"
  type    = "TXT"
  ttl     = "1"
}
