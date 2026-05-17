variable "staging_namespace" {
  description = "Name of the Kubernetes staging namespace"
  type        = string
  default     = "kijani-staging"
}

variable "production_namespace" {
  description = "Name of the Kubernetes production namespace"
  type        = string
  default     = "kijani-project"
}
