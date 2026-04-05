# DNS Record for the CDN
resource "cloudflare_record" "cdn" {
  zone_id = var.cloudflare_zone_id
  name    = var.cdn_subdomain
  value   = "storage.googleapis.com"
  type    = "CNAME"
  proxied = true
}

# Transform Rule: Rewrite URI to prepend bucket name
resource "cloudflare_ruleset" "path_rewrite" {
  zone_id     = var.cloudflare_zone_id
  name        = "Rewrite GCS Path"
  description = "Prepend bucket name to GCS requests"
  kind        = "zone"
  phase       = "http_request_transform"

  rules {
    action = "rewrite"
    action_parameters {
      uri {
        path {
          expression = "concat(\"/${google_storage_bucket.photos_bucket.name}\", http.request.uri.path)"
        }
      }
    }
    expression  = "http.host eq \"${var.cdn_subdomain}.${var.domain_name}\""
    description = "Prepend /${google_storage_bucket.photos_bucket.name} to path"
    enabled     = true
  }
}

# Origin Rule: Override Host header to storage.googleapis.com
resource "cloudflare_ruleset" "origin_override" {
  zone_id     = var.cloudflare_zone_id
  name        = "GCS Origin Host Override"
  description = "Override host header for GCS"
  kind        = "zone"
  phase       = "http_request_origin"

  rules {
    action = "route"
    action_parameters {
      host_header_override = "storage.googleapis.com"
    }
    expression  = "http.host eq \"${var.cdn_subdomain}.${var.domain_name}\""
    description = "Override host header to storage.googleapis.com"
    enabled     = true
  }
}

# Cache Rule: Cache Everything
resource "cloudflare_ruleset" "cache_settings" {
  zone_id     = var.cloudflare_zone_id
  name        = "CDN Caching Rules"
  description = "Cache everything for the photo CDN"
  kind        = "zone"
  phase       = "http_cache_settings"

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
