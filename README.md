# SSH key-pair creation and usage

SSH keys are a pair of public and private keys that are used to authenticate and establish an encrypted communication channel. Here are examples of how to generate keys used for hardening of a CCpilot V700 display, but the same principle can be used with any CrossControl device.

## How to generate a signing key 

```
ssh-keygen -t rsa -f v700-sign-key -m pem -b 4096 -N "" -C "V700-signature"
```
This will give the following output and files generated:

```
Generating public/private rsa key pair.
Your identification has been saved in v700-sign-key
Your public key has been saved in v700-sign-key.pub
The key fingerprint is:
SHA256:7ht4XvsU5ST3PRCZj+142+byZxWiOKrgA1/Hafcnos0 V700-signature
The key's randomart image is:
+---[RSA 4096]----+
|             .o  |
|             o.  |
|            ..B  |
|             O.=.|
|      . S . o =.+|
| .   . B + . o oo|
|  o.. + * + . . +|
|  .o.  =o+ = ...=|
|   .....=Eo.+  *+|
+----[SHA256]-----+
root@fd3ff6304bf7:~# ls
v700-sign-key  v700-sign-key.pub
```

The **v700-sign-key** is the private part of the key and must be kept safe, and the **v700-sign-key.pub** is the public part that can be shared with anyone. The next step is to convert the public key to a more readable format:

```
ssh-keygen -e -f v700-sign-key.pub -m PKCS8 > v700-sign-key.pub.pkcs8
```

This file should be copied to the v700 display. The private key is used for signing files and has to be kept secure. To sign a file, the following command is used. In this case the file is named *cc.auto.sh* and the output will be a signature file that can be used together with the public part of the key to validate that this file is exactly the same as when it was signed.

```
openssl dgst -sha256 -sign v700-sign-key -out cc-auto.sh.signature cc-auto.sh
```

To verify the signature, use the command:

```
openssl dgst -sha256 -verify v700-sign-key.pub.pkcs8 -signature cc-auto.sh.signature cc-auto.sh
```
The output can be either *Verified OK* or *Verified FAIL*. When used in a bash script, the return value is 0 if the verification is successful.

<br><br>

---

<br>

## How to generate a SSH login key 

Instead of using plaintext passwords to connect to a computer, a SSH passwordless login can be used. The principle is that a SSH key-pair is generated with a private and a public key. The public key is not secret and can be stored in a readable format on the display. The private key is used for logging in. Only a client that presents the correct private key can connect.

```
ssh-keygen -t rsa -f v700-login-key  -C "V700-login"
```

This will create a v700-login-key and a v700-login-key.pub file. To set up passwordless login for user *ccs*, copy:
*v700-login-key.pub* to */home/ccs/.ssh/authorized_keys*

Then you can log in using the private key file instead of providing a password:
```
ssh -i v700-login-key ccs@x.x.x.x (replace x.x.x.x with correct ip address)
```

After enabling SSH key-based login, it's recommended to disable password authentication for improved security. 
To disable password login, modify the following line in */etc/ssh/sshd_config*:

```
"#PasswordAuthentication yes" -> "PasswordAuthentication no"
```
