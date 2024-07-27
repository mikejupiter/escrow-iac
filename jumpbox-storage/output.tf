output "ebs_volume_id" {
  description = "The ID of the EBS volume"
  value       = aws_ebs_volume.jumpbox_storage.id
}