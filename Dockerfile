# Use the official Arch Linux base image
FROM archlinux:latest

# Install necessary packages
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm python openssh sudo systemd

# Create a user for SSH access
RUN useradd -m -s /bin/bash ansible \
    && echo 'ansible:password' | chpasswd \
    && echo 'ansible ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Configure SSH to allow password authentication
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Generate SSH host keys
RUN ssh-keygen -A

# Enable and start SSH service
RUN systemctl enable sshd.service

# Expose the SSH port
EXPOSE 22

# Start systemd
STOPSIGNAL SIGRTMIN+3
CMD ["/usr/lib/systemd/systemd"]
