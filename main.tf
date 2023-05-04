module "digger_test" {
  source  = "./modules/terraform-aws-s3"

  count = terraform.workspace == "dev" ? 1 : 0

  name           = "digger-test"
  environment    = terraform.workspace
  project        = "digger-test"
  partner        = "platform"
  owner          = "falcantara@redventures.com"
  classification = "Internal"

  sse_algorithm = "AES256"

  tags = {
    ServiceNowAppID = "N/A" 
    Name            = "redspine-shared-s3"
    Project         = "digger-test"
    Application     = "digger-test"
    Environment     = terraform.workspace
  }
}
