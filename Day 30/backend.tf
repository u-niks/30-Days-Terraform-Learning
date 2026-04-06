terraform {
    backend "s3" {
        bucket        = "-demo-terraform-state-bucket-name-11112222"
        key           = "env/terraform.tfstate"
        region        = "us-east-1"
        use_lockfile  = true
        encrypt       = true
    }
}