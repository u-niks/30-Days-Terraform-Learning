terraform {
    backend "s3" {
        bucket = "demo-terraform-state-file-1110001"
        key = "dev/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        use_lockfile = true
    }
}
