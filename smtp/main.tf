provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}

resource "aws_iam_user" "ses_smtp_user" {
  name = "ses-smtp-user"
}

resource "aws_iam_access_key" "ses_smtp_access_key" {
  user = aws_iam_user.ses_smtp_user.name
}

resource "aws_iam_user_policy" "ses_smtp_policy" {
  name   = "ses-smtp-policy"
  user   = aws_iam_user.ses_smtp_user.name

  policy = <<EOF
{
  "Version": "2024-03-11",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ses:SendRawEmail",
        "ses:SendEmail"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_ses_smtp_credential" "ses_smtp_credentials" {
  user = aws_iam_user.ses_smtp_user.name
}

output "ses_smtp_user_credentials" {
  value = {
    username = aws_iam_user.ses_smtp_user.name
    password = aws_ses_smtp_credential.ses_smtp_credentials.smtp_password
  }
}
