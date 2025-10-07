# Ansible

## 📑Table of Contents

- [Dependencies](#-dependencies)
- [Usage](#-usage)
- [Caution](#-caution)
- [Logging](#-logging)

## 🔗 Dependencies

- ansible [core 2.12.10]
- python version = 3.8.10 (default, May 26 2023, 14:05:08) [GCC 9.4.0]
- jinja version = 2.10.1

## 👨‍💻 Usage

- Access the **Muster** server remotely and use it within a secure environment.
- SSH access to the **Muster** server requires direct public key injection due to `PasswordAuthentication` being disabled.
- Files to be copied from the controller to the client must be located in the 📁production folder.

## 🚨 Caution

- **All variable files** related to security must be **encrypted**.
- **Inventory files** must be **encrypted** for use.
- Only users with a certain security level can use Ansible.
- Changes to the inventory file must be made only after a meeting.

## 📝 Logging

- A log file must be created for each date every time the playbook is executed.
