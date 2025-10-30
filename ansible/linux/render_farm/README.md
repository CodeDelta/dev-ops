# Ansible Muster Setup

This project is designed to automate the setup of a software environment using Ansible. It includes tasks for mounting NFS shares, creating a user, and installing the Muster software on multiple Rocky 9.5 machines.

## Project Structure

- **ansible.cfg**: Configuration settings for Ansible, including inventory paths and options.
- **inventory/hosts.ini**: Defines the target hosts for the Ansible playbooks.
- **group_vars/all.yml**: Variables that apply to all hosts, such as user credentials.
- **playbooks/ping.yml**: Playbook to test connectivity to the hosts.
- **playbooks/site.yml**: Main playbook that orchestrates the entire setup process.
- **playbooks/mount.yml**: Handles the mounting tasks as specified in the requirements.
- **playbooks/user.yml**: Responsible for creating the `muster` user and setting up the environment.
- **playbooks/muster.yml**: Manages the installation of Muster 9.0.14.
- **roles/mount/tasks/main.yml**: Contains tasks related to the mounting process.
- **roles/user/tasks/main.yml**: Contains tasks for user management.
- **roles/muster/files/Muster9.0.14.11632.x64.linux.tar.gz**: Installation file for Muster.
- **roles/muster/tasks/main.yml**: Contains tasks for installing Muster.

## Setup Instructions

1. **Clone the Repository**: Clone this repository to your local machine.
2. **Configure Inventory**: Update the `inventory/hosts.ini` file with the IP addresses of your target machines.
3. **Set Variables**: Modify `group_vars/all.yml` to include any necessary variables, such as user credentials.
4. **Run the Playbooks**:
   - First, test connectivity with the ping playbook:
     ```
     ansible-playbook playbooks/ping.yml
     ```
   - Then, execute the main setup playbook:
     ```
     ansible-playbook playbooks/site.yml
     ```

## Usage

This project is intended for use in environments where you need to set up multiple machines with the same configuration. It automates the process of installing necessary packages, creating users, and deploying software, ensuring consistency across your infrastructure.

## Requirements

- Ansible 2.14.18 or higher
- Access to the target machines with appropriate permissions
- Rocky Linux 9.5 environment on all machines

## License

This project is licensed under the MIT License. See the LICENSE file for more details.