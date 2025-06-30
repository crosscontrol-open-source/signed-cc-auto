#!/bin/sh

BUZZER_VOLUME=25

# Copy the updated cc-auto-root.sh and public part of the sign key to the device to enable signed installations.
# This scipt can only run once (on factory default units) unless the cc-auto.sh is signed with the corresponding key and the cc.auto.sh.signature file
# is also included on the USB stick.

USB_PATH=$1

# This will copy the files to main partition
cp ${USB_PATH}/v700-sign-key.pub.pkcs8 /etc/ssh
cp ${USB_PATH}/cc-auto-root.sh /usr/bin

# This will mount and copy the files to the rescue partition
RESCUE_MOUNT=/mnt/rescue
mkdir -p ${RESCUE_MOUNT}
mount /dev/mmcblk1p2 ${RESCUE_MOUNT}
cp ${USB_PATH}/v700-sign-key.pub.pkcs8 ${RESCUE_MOUNT}/etc/ssh
cp ${USB_PATH}/cc-auto-root.sh ${RESCUE_MOUNT}/usr/bin
umount ${RESCUE_MOUNT}
rmdir ${RESCUE_MOUNT}

# Sync to make sure files are written to flash
sync

# Play a tone to indicate that installation is complete
ccsettingsconsole --buzzer --frequency=1000 --volume=$BUZZER_VOLUME --status=enable
sleep 1
ccsettingsconsole --buzzer --frequency=1000 --volume=$BUZZER_VOLUME --status=disable
ccsettingsconsole --buzzer --frequency=1500 --volume=$BUZZER_VOLUME --status=enable
sleep 1
ccsettingsconsole --buzzer --frequency=1500 --volume=$BUZZER_VOLUME --status=disable
ccsettingsconsole --buzzer --frequency=2000 --volume=$BUZZER_VOLUME --status=enable
sleep 1
ccsettingsconsole --buzzer --frequency=2000 --volume=$BUZZER_VOLUME --status=disable



