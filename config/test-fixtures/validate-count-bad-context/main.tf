resource "aws_instance" "foo" {
}

output "no_count_in_output" {
  value = "${count.index}"
}
