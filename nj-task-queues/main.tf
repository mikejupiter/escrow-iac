provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
}

# Define the main SQS queue
resource "aws_sqs_queue" "etickets_for_upload" {
  name                      = "etickets_for_upload"
  delay_seconds             = 0  # 20 minutes delay
  max_message_size          = 262144  # 256 KB message size limit
  message_retention_seconds = 86400  # Messages will be retained for 1 day
  visibility_timeout_seconds = 600  # Default visibility timeout
}


# Define the failure processing queue
resource "aws_sqs_queue" "etickets_for_upload_failure" {
  name = "etickets_for_upload_failure"
}




