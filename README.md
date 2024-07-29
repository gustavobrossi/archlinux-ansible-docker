# archlinux-ansible-docker

This repository contains a Dockerfile to create an Arch Linux container with systemd, SSH, and Ansible support (python and ansible user). This setup is useful to be used as a target host for testing of Ansible playbooks and roles in a controlled environment.

## Features

- **Arch Linux Base**: Uses the latest Arch Linux base image.
- **Systemd**: Includes systemd for service management within the container.
- **SSH**: Configured for SSH access.
- **Ansible Support**: Ready to run Ansible playbooks as target host.

## Prerequisites

- Docker installed on your system.
- Ansible installed on your controller machine (the machine from which you will run Ansible commands).

## Build the Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and run:

```sh
docker build -t archlinux-ansible .
```

## Run the Docker Container

To run the Docker container with systemd support:

```sh
docker run --privileged -d -p 2222:22 --name archlinux-server archlinux-ansible
```

## SSH Access

You can SSH into the running container using:

```sh
ssh ansible@localhost -p 2222
```

The default password for the ansible user is password.

## Ansible Setup
Create an inventory file named hosts with the following content:

```ini
[archlinux]
localhost ansible_port=2222 ansible_user=ansible ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

## One-Liner Command to Test Ansible Ping Module
Use the following command to test the Ansible ping module against the container:

```sh
ansible -i hosts archlinux -m ping --user ansible --ask-pass
```

This command will prompt you for the SSH password (default is password), and then it will attempt to ping the Arch Linux container using Ansible.

## Notes
* Security: The default setup uses password-based SSH login. For production use, consider setting up SSH key-based authentication.
* Systemd and Cgroups: The setup assumes Docker’s default cgroup configuration. If you encounter issues with service management, consider mounting cgroups manually (-v /sys/fs/cgroup:/sys/fs/cgroup:ro).

## License
This project is licensed under the MIT License.