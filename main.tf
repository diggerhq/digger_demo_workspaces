module "redspine_shared_s3" {
  version = "~> 5.0"
  source  = "app.terraform.io/RVStandard/s3/aws"

  count = terraform.workspace == "dev" ? 1 : 0

  name           = "redspine-shared-s3"
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
