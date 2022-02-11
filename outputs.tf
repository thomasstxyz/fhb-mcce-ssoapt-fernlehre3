output "podtatohead-main_ssh_address" {
  value = "${aws_instance.podtatohead-main.public_ip}"
}

output "homepage_url" {
  value = "https://${aws_instance.podtatohead-main.public_ip}.nip.io"
}

output "application_name" {
  value = "secure-podtatohead-on-aws"
}

output "auth_callback_url" {
  value = "https://${aws_instance.podtatohead-main.public_ip}.nip.io/oauth2/callback"
}

output "podtato-url-insecure" {
  value = "http://${aws_instance.podtatohead-main.public_ip}:8080"
}
