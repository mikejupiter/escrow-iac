# Jumpbox VM


# Prepare

Create the host ssh key to be able to get the password
```bash
ssh-keygen -t rsa -b 2048 -C "mikeg@theserengeti.io"

ssh-keygen -p -m PEM -f jumpbox_id_rsa
```

The second command is needed to generate the file for using it with AWS which does not understand OpenSSH format and want RSA format