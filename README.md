# dynamoosejs/infrastructure

This repository is responsible for housing and managing the settings and configuration for Dynamoose infrastructure, primarily [dynamoosejs.com](https://dynamoosejs.com).

## Providers

- Cloudflare - DNS Service/CDN (caching)
- AWS S3 - Website Hosting (`us-west-2` region)

## Scope

Currently this repositoiry manages the following:

- DNS Settings (ex. updating the [`cloudflare.tf`](cloudflare.tf) file on the `master branch` will update the actual DNS settings in Cloudflare)

We are considering expanding this in the future to include:

- Management of S3 buckets (adding, modifying, deleting, etc.)
- Domain management (renewing, etc.)
- Other Cloudflare options (caching settings, page rules, SSL settings, minification settings, etc.)

## Dynamoose apex on rrainn Cloud Pages

Keep Cloudflare authoritative. Schedule the switch between Dynamoose releases
so the CloudFront origin remains available as a rollback target.

1. Create or select the subscribed Pages site and publish the latest stable
   Dynamoose docs to its generated hostname. In Pages, add `dynamoosejs.com`
   as a custom domain.
2. Commit a `dynamoose-pages.auto.tfvars` file with the generated hostname
   and the ownership TXT value returned by Pages. Use the shape below and
   leave `cutover = false`. Review the Terraform plan, then merge to let
   the existing workflow apply the proof record.
3. Verify ownership in Pages. Add the supplied DNS-01 target as
   `certificate_cname` in the same file and let Terraform apply it. Leave
   that record in place for certificate renewal. Wait for Cloud to report
   ready and check the apex certificate and documentation over HTTPS using
   `curl --resolve` against the Pages serving addresses.
4. In a separate change, set `cutover = true`. Confirm the plan updates the
   apex CNAME target and sets `proxied = false` in the same apply. Cloudflare
   flattens the DNS-only apex CNAME and Pages serves HTTPS directly. Verify
   the authoritative A and AAAA answers, public HTTPS over both address
   families, and the existing versioned and prerelease sites.

```hcl
pages_apex = {
  hostname          = "<generated Pages hostname>"
  ownership_value   = "<Pages TXT value>"
  # certificate_cname = "<Pages DNS-01 target>"
  cutover           = false
}
```

To roll back traffic, set `cutover = false` and merge the change. Terraform
restores the CloudFront target with the Cloudflare proxy enabled. Keep the
CloudFront distribution and S3 bucket available throughout the cutover.
