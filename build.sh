MANIFEST="https://github.com/PitchBlackRecoveryProject/manifest_pb -b android-12.1"
DEVICE=KD7
MAKE=tecno
DT_LINK="https://github.com/Nubuki-all/recovery_device_tecno_KD7 -b pbrp"
DT_PATH=device/$MAKE/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir ~/pbrp && cd ~/pbrp

echo " ===+++ Syncing Recovery Sources +++==="
repo init --depth=1 -u $MANIFEST
repo sync
#repo sync
git clone --depth=1 $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
export ALLOW_MISSING_DEPENDENCIES=true
export BUILD_BROKEN_DUP_RULES=true
. build/envsetup.sh
echo " source build/envsetup.sh done"
lunch omni_${DEVICE}-eng || abort " lunch failed with exit status $?"
echo " lunch omni_${DEVICE}-eng done"
#mka recoveryimage || abort " mka failed with exit status $?"
mka pbrp
echo " mka recoveryimage done"

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="
version=$(cat bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d \" -f2)
OUTFILE=TWRP-${version}-${DEVICE}-$(date "+%Y%m%d-%I%M").zip

cd out/target/product/$DEVICE
curl -sL https://git.io/file-transfer | sh 

./transfer wet *.zip

./transfer wet recovery.img
