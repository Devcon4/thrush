variable "gke_master_ipv4_cidr_block" {
  type    = string
  default = "172.23.0.0/28"
}
variable "region" {
  type = string
}
variable "zone" {
  type = string
}