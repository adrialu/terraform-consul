terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/key"
    region = "eu-west-2"
  }
}