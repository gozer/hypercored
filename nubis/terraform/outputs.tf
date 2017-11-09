output "EIP" {
  value = "${aws_eip.hypercored.id}"
}

output "Address" {
  value = "${aws_eip.hypercored.public_ip}"
}

