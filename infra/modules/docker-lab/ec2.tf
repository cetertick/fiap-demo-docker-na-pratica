resource "aws_key_pair" "instructor" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.ssh_public_key_path)

  tags = merge(local.common_tags, { Name = "${var.project_name}-key" })
}

resource "aws_instance" "docker_host" {
  ami                         = data.aws_ami.ubuntu_2204.id
  instance_type               = var.instance_type
  subnet_id                   = local.selected_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  key_name                    = aws_key_pair.instructor.key_name
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user-data.sh", {
    application_port = var.application_port
    project_name     = var.project_name
  })

  root_block_device {
    volume_size = 24
    volume_type = "gp3"
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-docker-host" })
}
