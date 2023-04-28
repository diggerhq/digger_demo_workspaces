
resource "null_resource" "test1" {
}

resource "null_resource" "devonly" {
  count = "${terraform.workspace == "dev" ? 1 : 0}"
}

resource "null_resource" "prodonly" {
  count = "${terraform.workspace == "prod" ? 1 : 0}"
}
