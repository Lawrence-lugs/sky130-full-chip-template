FROM hpretl/iic-osic-tools:latest

# Install sudo
USER root

RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && \
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list && \
    apt-get update && \
    apt-get install -y sudo \
    sublime-text && \
    ln -sf /opt/sublime_text/sublime_text /usr/local/bin/sublime && \
    echo 'export PATH="/opt/sublime_text:$PATH"' > /etc/profile.d/sublime.sh && \
    chmod +x /etc/profile.d/sublime.sh

RUN useradd -s /bin/bash designer
RUN usermod -aG sudo designer

RUN echo "designer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/designer \
    && chmod 0440 /etc/sudoers.d/designer

WORKDIR /workspaces

USER designer