output "staging_namespace" {
  description = "The name of the Kubernetes staging namespace"
  value       = kubernetes_namespace.kijani_staging.metadata[0].name
}

output "production_namespace" {
  description = "The name of the Kubernetes production namespace"
  value       = kubernetes_namespace.kijani_project.metadata[0].name
}
