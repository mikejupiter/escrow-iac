provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
}

# Define the main SQS queue
resource "aws_sqs_queue" "dev_etickets_for_upload" {
  name                      = "dev_etickets_for_upload"
  delay_seconds             = 0  # 20 minutes delay
  max_message_size          = 262144  # 256 KB message size limit
  message_retention_seconds = 86400  # Messages will be retained for 1 day
  visibility_timeout_seconds = 600  # Default visibility timeout
}


# Define the failure processing queue
resource "aws_sqs_queue" "dev_etickets_for_upload_failure" {
  name = "dev_etickets_for_upload_failure"
}

# Define the queue to initiate eTicketing missed images checks per muni/court pair
resource "aws_sqs_queue" "dev_e_ticketing_missed_image_muni_courts" {
  name = "dev_e_ticketing_missed_image_muni_courts"
}

# Define the queue to handle missed eTicketing image
resource "aws_sqs_queue" "dev_e_ticketing_missed_image" {
  name = "dev_e_ticketing_missed_image"
}


# Create IAM user sts_access_dev
resource "aws_iam_user" "sts_access_dev" {
  name = "sts_access_dev"
}

# Create IAM policy allowing receive and send messages to the main SQS queue
resource "aws_iam_policy" "sqs_access_policy_dev" {
  name        = "sqs_access_policy_dev"
  description = "Allows receive and send messages to the main SQS queue"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:SendMessage"
        ],
        Resource  = [
          aws_sqs_queue.dev_e_ticketing_missed_image_muni_courts.arn,
          aws_sqs_queue.dev_etickets_for_upload.arn,
          aws_sqs_queue.dev_e_ticketing_missed_image_muni_courts.arn,
          aws_sqs_queue.dev_e_ticketing_missed_image.arn
        ]
      }
    ]
  })
}

# Attach the policy to the IAM user
resource "aws_iam_user_policy_attachment" "attach_policy_to_user_dev" {
  user       = aws_iam_user.sts_access_dev.name
  policy_arn = aws_iam_policy.sqs_access_policy_dev.arn
}

