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

# Create the IAM Role with an S3 Access Policy
resource "aws_iam_role" "nj_photos_dev_writer_role" {
  name               = "nj-photos-dev-writer-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach policy to allow access to the specific S3 bucket
resource "aws_iam_policy" "nj_photos_dev_writer_policy" {
  name        = "nj-photos-dev-writer-policy"
  description = "Policy to allow access to the nj_photos_dev bucket"
  policy      = <<EOF
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

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_nj_photos_dev_writer_policy" {
  role       = aws_iam_role.nj_photos_dev_writer_role.name
  policy_arn = aws_iam_policy.nj_photos_dev_writer_policy.arn
}

# Create an IAM user who will assume the role
resource "aws_iam_user" "nj_photos_dev_writer_user" {
  name = "nj-photos-dev-writer-user"
}

# 6. Attach AssumeRole policy to the user to allow assuming the nj_photos_dev_writer_role
resource "aws_iam_user_policy" "nj_photos_dev_writer_user_assume_role_policy" {
  name   = "AllowAssumeRole"
  user   = aws_iam_user.nj_photos_dev_writer_user.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "${aws_iam_role.nj_photos_dev_writer_role.arn}"
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
