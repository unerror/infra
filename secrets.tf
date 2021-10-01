data "sops_file" "secrets" {
  source_file = "secrets.enc.yaml"
  input_type  = "yaml"
}

data "sops_file" "base-chart-values" {
  source_file = "charts/base/secrets.yaml"
  input_type  = "yaml"
}
