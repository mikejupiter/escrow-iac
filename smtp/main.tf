provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}


resource "aws_iam_user" "smtp_user" {
  name = "g2_smtp_user"
}

resource "aws_iam_access_key" "smtp_user" {
  user = aws_iam_user.smtp_user.name
}

data "aws_iam_policy_document" "ses_sender" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ses_sender" {
  name        = "ses_sender"
  description = "Allows sending of e-mails via Simple Email Service"
  policy      = data.aws_iam_policy_document.ses_sender.json
}

resource "aws_iam_user_policy_attachment" "g2-smtp-user-attach" {
  user       = aws_iam_user.smtp_user.name
  policy_arn = aws_iam_policy.ses_sender.arn
}

output "smtp_username" {
  value = aws_iam_access_key.smtp_user.id
}

output "smtp_password" {
  value = aws_iam_access_key.smtp_user.ses_smtp_password_v4
  sensitive = true
}

