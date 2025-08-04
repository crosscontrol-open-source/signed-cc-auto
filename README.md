# SSH key-pair creation and usage
NOTE! This instruction is applicable for CC Linux 2 and 3 only. CC Linux 4 is using RAUC for even more robust and secure software updates.

SSH keys are cryptographic key pairs used to authenticate and establish secure, encrypted communication channels. The following examples demonstrate how to generate and use SSH keys for hardening a CCpilot V700 display, though the same principles apply to any CrossControl display.

## Generating a Signing Key  
To create a 4096-bit RSA signing key in PEM format:

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

The **v700-sign-key** is the private key and should be kept secure, while the **v700-sign-key.pub** is the public key and can be shared freely. The next step is to convert the public key into a more portable format (PKCS#8).

```
ssh-keygen -e -f v700-sign-key.pub -m PKCS8 > v700-sign-key.pub.pkcs8
```

This file should be copied to the v700 display. The private key is used to sign files and must be kept secure. To sign a file, use the following command. In this example, the file is named *cc.auto.sh*, and the output will be a signature file. This signature, along with the public key, can be used to verify that the file has not been altered since it was signed.

```
openssl dgst -sha256 -sign v700-sign-key -out cc-auto.sh.signature cc-auto.sh
```

To verify the signature, use the command:

```
openssl dgst -sha256 -verify v700-sign-key.pub.pkcs8 -signature cc-auto.sh.signature cc-auto.sh
```
The output can be either *Verified OK* or *Verified FAIL*. When used in a bash script, the return value is 0 if the verification is successful.

<br>

---

<br>

## Generating an SSH Login Key

Rather than using plaintext passwords to access a system, SSH key-based authentication provides a more secure and efficient alternative. This method involves generating a pair of cryptographic keys: a private key and a public key. The public key, which is safe to share, can be stored in plain text on the target device (such as a display). The private key remains securely on the client device and is used to authenticate the user. Only a client with the correct private key can successfully log in, eliminating the need to transmit passwords over the network.

```
ssh-keygen -t rsa -f v700-login-key  -C "V700-login"
```

This will create a v700-login-key and a v700-login-key.pub file. To set up key-based login for user *ccs*, copy:
*v700-login-key.pub* to */home/ccs/.ssh/authorized_keys*

Then you can log in using the private key file instead of providing a password:
```
ssh -i v700-login-key ccs@<ip address> (replace <ip address> with the ip address of the display)
```

Once SSH key-based login is enabled, it is strongly recommended to disable password authentication to enhance system security.
To disable password-based login, modify the following line in */etc/ssh/sshd_config*:

```
"#PasswordAuthentication yes" -> "PasswordAuthentication no"
```

