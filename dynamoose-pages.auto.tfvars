# Keep ownership and certificate delegation in place for the Pages hostname.
pages_apex = {
  hostname          = "times-square-pink-cgpgr.pages.cloud.rrainn.com"
  ownership_value   = "rrainn-pages=32d95af955f7c93305aa9439b91f87e232cbbb81b58d5cd3"
  certificate_cname = "c-zxjtox2h5g3yoqbvoq66xpzdsqkhhfhwiyzm3ptnwi54htsis6xq.acme.rrainn.net"
  cutover           = true
}
