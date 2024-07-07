rm -rf google-chrome-stable_current_amd64.deb
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
CHROME_VERSION=$(dpkg --info google-chrome-stable_current_amd64.deb |grep Version|cut -d':' -f 2|tr -d " ")
echo chrome version: $CHROME_VERSION
sudo docker buildx build -t socrateslee/xvfb-chrome:$CHROME_VERSION .
