module "foo" {
  count = 5
  value = "${count.index}"
}
