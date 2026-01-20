# IAM Module Variables

variable "cluster_name" {
    description = "Name of the EKS Cluster"
    type        = string
}

variable "tags" {
    description = "Tags to apply to all resources"
    type        = map(string)
    default     = {}
}
