output "kubenetes-Servers-PublicIP" {
  value = aws_instance.kubenetes-Servers.*.public_ip
}
output "kubenetes-Servers-PrivateIP" {
  value = aws_instance.kubenetes-Servers.*.private_ip
}