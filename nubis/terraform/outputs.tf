output "Address" {
  value = "${aws_eip.hypercored.public_ip}"
}

output "DNS" {
  value = "http://${module.dns.fqdn}:3283/"
}
