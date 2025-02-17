plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "random" {
    enabled = true
    source  = "terraform-linters/tflint-ruleset-random"
    version = "0.1.0"
} 