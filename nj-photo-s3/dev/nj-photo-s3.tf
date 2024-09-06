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


# Create the IAM role that will have access to the S3 bucket
resource "aws_iam_role" "nj_photos_dev_writer_role" {
  name = "nj-photos-dev-writer-role"

  # Trust policy to allow the IAM user to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_user.nj_photos_dev_writer_user.arn  # Allow the specific IAM user to assume this role
        },
        Action = "sts:AssumeRole"
      },
    ],
  })
}

# Attach a policy to the role to allow S3 bucket access
resource "aws_iam_role_policy" "nj_photos_dev_writer_policy" {
  name = "nj-photos-dev-writer-policy"
  role = aws_iam_role.nj_photos_dev_writer_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = "${aws_s3_bucket.nj_photos_dev.arn}/*"  # Use bucket ARN reference
      },
      {
        Effect = "Allow",
        Action = "s3:ListBucket",
        Resource = aws_s3_bucket.nj_photos_dev.arn  # List objects in the bucket
      },
    ],
  })
}

# Create an IAM user who will assume the role
resource "aws_iam_user" "nj_photos_dev_writer_user" {
  name = "nj-photos-dev-writer-user"
}

# Allow the IAM user to assume the role via sts:AssumeRole
resource "aws_iam_user_policy" "s3_access_user_policy" {
  name = "s3_access_user_policy"
  user = aws_iam_user.nj_photos_dev_writer_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = aws_iam_role.nj_photos_dev_writer_role.arn 
      },
    ],
  })
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
