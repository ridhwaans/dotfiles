# Ubuntu 22.04.1 LTS http://releases.ubuntu.com/jammy/ubuntu-22.04.1-desktop-amd64.manifest
FROM ubuntu

# Update apt cache
RUN apt update

# Install system packages
RUN apt install -y \
  curl \
  sudo \
;

ARG USERNAME=ridhwaans

# Create and configure user
RUN useradd -ms /bin/bash $USERNAME
# User with empty password
RUN echo "$USERNAME:$USERNAME" | chpasswd
# Enable passwordless sudo for user
RUN mkdir -p /etc/sudoers.d && \
             echo "$USERNAME ALL= NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME && \
             chmod 0440 /etc/sudoers.d/$USERNAME

# Default non-root user
USER $USERNAME
ENV HOME /home/$USERNAME

# Dotfiles install script
RUN curl -fsSL https://raw.githubusercontent.com/ridhwaans/dotfiles/master/setup.sh | bash

# Starting directory
WORKDIR $HOME

# Run a zsh session
CMD [ "/bin/zsh" ]
