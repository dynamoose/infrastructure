mock_provider "cloudflare" {}

variables {
  zone = "00000000000000000000000000000000"
}

run "unconfigured" {
  command = plan

  assert {
    condition     = cloudflare_record.dynamoosejs_com.value == "dmz8ymrutkf3e.cloudfront.net" && cloudflare_record.dynamoosejs_com.proxied
    error_message = "An unconfigured Pages site must keep serving the apex through CloudFront and the Cloudflare proxy."
  }

  assert {
    condition     = length(cloudflare_record.dynamoosejs_com_pages_ownership) == 0 && length(cloudflare_record.dynamoosejs_com_pages_certificate) == 0
    error_message = "An unconfigured Pages site must not create validation records."
  }
}

run "ownership_only" {
  command = plan

  variables {
    pages_apex = {
      hostname        = "dynamoose-example.pages.cloud.rrainn.com"
      ownership_value = "rrainn-pages=example-proof"
    }
  }

  assert {
    condition     = cloudflare_record.dynamoosejs_com_pages_ownership[0].type == "TXT" && length(cloudflare_record.dynamoosejs_com_pages_certificate) == 0 && cloudflare_record.dynamoosejs_com.proxied
    error_message = "Ownership must be provable before certificate issuance and without changing the apex proxy."
  }
}

run "certificate_preparation_and_rollback" {
  command = plan

  variables {
    pages_apex = {
      hostname          = "dynamoose-example.pages.cloud.rrainn.com"
      ownership_value   = "rrainn-pages=example-proof"
      certificate_cname = "example.acme.invalid"
      cutover           = false
    }
  }

  assert {
    condition     = !cloudflare_record.dynamoosejs_com_pages_certificate[0].proxied && cloudflare_record.dynamoosejs_com.value == "dmz8ymrutkf3e.cloudfront.net" && cloudflare_record.dynamoosejs_com.proxied
    error_message = "Certificate delegation must use DNS only while the traffic record retains or restores the proxied CloudFront target."
  }
}

run "dns_only_cutover" {
  command = plan

  variables {
    pages_apex = {
      hostname          = "dynamoose-example.pages.cloud.rrainn.com"
      ownership_value   = "rrainn-pages=example-proof"
      certificate_cname = "example.acme.invalid"
      cutover           = true
    }
  }

  assert {
    condition     = cloudflare_record.dynamoosejs_com.value == "dynamoose-example.pages.cloud.rrainn.com" && !cloudflare_record.dynamoosejs_com.proxied
    error_message = "The apex must point directly to Pages with proxying disabled."
  }

  assert {
    condition = alltrue([
      cloudflare_record.alpha_dynamoosejs_com.proxied,
      cloudflare_record.beta_dynamoosejs_com.proxied,
      cloudflare_record.v1_dynamoosejs_com.proxied,
      cloudflare_record.v2_dynamoosejs_com.proxied,
      cloudflare_record.v3_dynamoosejs_com.proxied,
    ])
    error_message = "The legacy hostnames must continue to use the Cloudflare proxy."
  }
}

run "cutover_requires_certificate_delegation" {
  command = plan

  variables {
    pages_apex = {
      hostname        = "dynamoose-example.pages.cloud.rrainn.com"
      ownership_value = "rrainn-pages=example-proof"
      cutover         = true
    }
  }

  expect_failures = [var.pages_apex]
}
