#!/bin/sh
#
# cc-auto-root.sh - wrapper for cc-auto.sh
#
#
# Args: $1 = cc-auto.sh - script
#       $2 = usb-mount point
#

. /etc/cc-auto.conf

CC_AUTO_FILE=$1
CC_AUTO_SIGN_FILE=${CC_AUTO_FILE}.signature
PATH_TO_PUBLIC_SIGN_KEY=/etc/ssh/v700-sign-key.pub.pkcs8

# Verify signature of cc-auto.sh file on USB stick
openssl dgst -sha256 -verify ${PATH_TO_PUBLIC_SIGN_KEY} -signature ${CC_AUTO_SIGN_FILE} ${CC_AUTO_FILE}

# Check if return value from 'openssl dgst' is OK or FAIL
if [ $? -eq 0  ]; then
   echo "Verified Digital Signature...OK" | tee /dev/kmsg
   $1 $2  # this command will run the cc-auto.sh script
else
   echo "Verified Digital Signature...FAIL" | tee /dev/kmsg
   # Blink red LED for 3 seconds to indicate signature verification failure
   ccsettingsconsole --led --color=red --frequency=7 --dutycycle=50
   sleep 3
   ccsettingsconsole --led --color=green --frequency=7 --dutycycle=100
fi
