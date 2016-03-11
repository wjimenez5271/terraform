variable "count" {}

module "child" {
    source = "./child"
    rcount = "${var.count}"
}
