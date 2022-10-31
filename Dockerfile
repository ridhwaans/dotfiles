FROM ubuntu

# Update apt cache
RUN apt-get update

# Install system packages
RUN apt-get install -y \
  curl \
  sudo \
;

# SSH user
ENV USERNAME ridhwaans
ENV USERPASSWORD ridhwaans
# Create and configure user
RUN useradd -ms /bin/bash $USERNAME
# User with empty password
RUN echo "$USERNAME:$USERPASSWORD" | chpasswd
# Enable passwordless sudo for user
RUN mkdir -p /etc/sudoers.d && \
             echo "$USERNAME ALL= NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME && \
             chmod 0440 /etc/sudoers.d/$USERNAME

ENV HOME /home/$USERNAME

RUN curl -L https://raw.githubusercontent.com/$USERNAME/dotfiles/master/remote-setup.sh | bash

# Create image (approx. runtime 580.2s / ~10 min)
# docker build -t test . --progress=plain --no-cache
# Login ZSH
# docker run -w /home/ridhwaans -it test /bin/zsh