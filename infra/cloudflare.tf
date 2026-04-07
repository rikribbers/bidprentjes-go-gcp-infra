# DNS Record for the CDN
resource "cloudflare_record" "cdn" {
  zone_id = var.cloudflare_zone_id
  name    = var.cdn_subdomain
  content = "storage.googleapis.com"
  type    = "CNAME"
  proxied = true
}

# Cache Rule: Cache Everything
resource "cloudflare_ruleset" "cache_settings" {
  zone_id     = var.cloudflare_zone_id
  name        = "CDN Caching Rules"
  description = "Cache everything for the photo CDN"
  kind        = "zone"
  phase       = "http_request_cache_settings"

  rules {
    action = "set_cache_settings"
    action_parameters {
      cache = true
      edge_ttl {
        mode    = "override_origin"
        default = 2592000 # 1 month
      }
      browser_ttl {
        mode    = "override_origin"
        default = 86400 # 1 day
      }
    }
    expression  = "http.host eq \"${var.cdn_subdomain}.${var.domain_name}\""
    description = "Cache Everything and set TTLs"
    enabled     = true
  }
}
