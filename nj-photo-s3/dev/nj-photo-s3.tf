provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
}

resource "aws_s3_bucket" "nj_photos_dev" {
  bucket = "nj-photos-dev" 
}

# Add lifecycle rules to transition objects to cheaper storage (e.g., Glacier) after 1 year
resource "aws_s3_bucket_lifecycle_configuration" "nj_photos_dev_lifecycle" {
  bucket = aws_s3_bucket.nj_photos_dev.id

  rule {
    id     = "transition-to-glacier"
    status = "Enabled"

    filter {
      prefix = ""  # Apply to all objects in the bucket
    }

    transition {
      days          = 365  # Transition objects to Glacier after 365 days
      storage_class = "GLACIER"
    }

    expiration {
      days = 2000  # Optionally, expire (delete) objects after 5+ years
    }
  }
}

# Create an IAM user who will assume the role
resource "aws_iam_user" "nj_photos_dev_writer_user" {
  name = "nj-photos-dev-writer-user"
}

# Attach a policy to the user for S3 bucket access
resource "aws_iam_user_policy" "nj_photos_dev_writer_user_policy" {
  name = "nj-photos-dev-writer-user-policy"
  user = aws_iam_user.nj_photos_dev_writer_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.nj_photos_dev.id}",
        "arn:aws:s3:::${aws_s3_bucket.nj_photos_dev.id}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "s3_access_user_access_key" {
  user = aws_iam_user.nj_photos_dev_writer_user.name
}

output "access_key_id" {
  value     = aws_iam_access_key.s3_access_user_access_key.id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.s3_access_user_access_key.secret
  sensitive = true
}
