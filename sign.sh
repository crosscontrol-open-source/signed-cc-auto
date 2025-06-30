
#!/bin/sh

# This command will sign the cc.auto.sh script file, making sure the content is unaltered compared to when it was signed.

openssl dgst -sha256 -sign v700-sign-key -out cc-auto.sh.signature cc-auto.sh

# The next step should be to copy cc-auto.sh, cc-auto.sh.signature (plus any extra files used by cc-auto.sh to a USB stick).

# Note: Only the content of cc-auto.sh is verified with this approach. If any extra files like a tar archive or other scripts are called from cc-auto.sh 
# you must add steps to make sure they are also not modified to be sure of that is installed to the display!


