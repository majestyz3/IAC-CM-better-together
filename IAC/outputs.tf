output "linux_public_ip" {
  value = aws_instance.linux.public_ip
}

output "windows_public_ip" {
  value = aws_instance.windows.public_ip
}
