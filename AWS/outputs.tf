output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "PUBLIC IP address of the EC2 instance (Elastic IP - Static)"
  value       = aws_eip.web.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.web.public_dns
}

output "web_server_url" {
  description = "URL to access the web server via PUBLIC IP"
  value       = "http://${aws_eip.web.public_ip}"
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.ec2.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "ssh_command" {
  description = "SSH command to connect to instance using PUBLIC IP"
  value       = "ssh -i /path/to/your/key.pem ec2-user@${aws_eip.web.public_ip}"
}

output "aws_linux_system" {
  description = "Operating system - Amazon Linux 2"
  value       = "Amazon Linux 2 (AWS)"
}
