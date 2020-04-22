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
