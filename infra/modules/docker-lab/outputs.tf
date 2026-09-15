output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_url" {
  value = "http://${aws_lb.this.dns_name}"
}

output "instance_id" {
  value = aws_instance.docker_host.id
}

output "instance_public_ip" {
  value = aws_instance.docker_host.public_ip
}

output "ssh_command" {
  value = "ssh -i ${var.ssh_public_key_path} ubuntu@${aws_instance.docker_host.public_ip}"
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}
