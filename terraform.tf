data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "testbuckethelloworld"
    key = "${var.aws_region}/vpc/terraform.tfstate"
    region = "${var.remote_state_region}"
  }
}
