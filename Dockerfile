FROM ubuntu:latest

COPY sources.list /etc/apt/sources.list
COPY chrome.sh /user/local/bin/chrome.sh
COPY google-chrome-stable_current_amd64.deb /root/google-chrome-stable_current_amd64.deb
RUN chmod +x /user/local/bin/chrome.sh
RUN apt-get update && apt-get install -y wget libgbm-dev xvfb weston socat net-tools sudo
RUN apt install -y fonts-liberation libasound2-dev libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcairo2 libcups2 libcurl4 libdbus-1-3 libglib2.0-0 libgtk-4-1 libnspr4 libnss3 libpango-1.0-0 libu2f-udev libxdamage1 libxcomposite1 libxkbcommon0 xdg-utils
RUN dpkg -i /root/google-chrome-stable_current_amd64.deb
RUN rm -f /root/google-chrome-stable_current_amd64.deb
RUN useradd -m -s /bin/bash chrome
RUN usermod -a -G sudo chrome
RUN echo "chrome ALL=(ALL:ALL) NOPASSWD: ALL" | tee "/etc/sudoers.d/dont-prompt-chrome-for-sudo-password"

# Clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup
USER chrome
ENTRYPOINT ["/user/local/bin/chrome.sh"]
