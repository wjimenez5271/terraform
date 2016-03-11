variable "rcount" {}

resource "aws_instance" "foo" {
  count = "${var.rcount}"
}
