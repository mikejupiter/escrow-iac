# SMTP server on Amazon

## Testing

To test you can use this script:

```python
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# SES SMTP server settings
smtp_server = 'email-smtp.us-east-1.amazonaws.com'  # Replace {region} with your AWS region
smtp_port = 587  # SES SMTP port

# SES SMTP credentials
smtp_username = 'usertocken'
smtp_password = 'password'

# Sender and recipient email addresses
sender = 'locksmith@mycompany.com'
recipient = 'test@emal.com'

# Email content
subject = 'Test Email via SES SMTP'
body = 'This is a test email sent via SES SMTP using Python.'

# Create message
msg = MIMEMultipart()
msg['From'] = sender
msg['To'] = recipient
msg['Subject'] = subject
msg.attach(MIMEText(body, 'plain'))

# Connect to the SMTP server
server = smtplib.SMTP(smtp_server, smtp_port)
server.starttls()
server.login(smtp_username, smtp_password)

# Send the email
server.sendmail(sender, recipient, msg.as_string())

# Close the connection
server.quit()

```