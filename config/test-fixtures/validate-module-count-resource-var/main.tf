resource "aws_instance" "foo" {}

module "web" {
    count = "${aws_instance.foo.bar}"
}
