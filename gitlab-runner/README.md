# GitLab Runner with Docker

## 📃 Description

This project includes the Docker Compose file and certificates for running a CI/CD GitLab Runner.  
This project must satisfy the following constraints and conditions.

## 🏗️ Architecture

![Architecture Diagram](./architecture.svg)

- **The certificate file is not included in this project.**
- When creating a Runner, the person delegated with authority requests the certificate from the administrator.

## 📑Table of Contents

- [Dependencies](#dependencies)
- [Requirements](#requirements)
- [Usage](#usage)

## 🔗 Dependencies

- docker
- docker compose

## 📝 Requirements

- ⚠️**Creating a runner using a registration token is prohibited.**
- It must be created in the GitLab UI and a user with the granted permission can create the runner.
- Able to access the internal repository being served on the same network.
- Network state that allows downloading packages required for the build (Trust➡️Wan)
- The host that will run the GitLab Runner must **strictly** satisfy the above requirements.

## 👨‍💻 Usage

- Request and obtain the certificate file from the administrator
- Place it under the `common` folder with the name `star_your_domain_com.crt`.
- After running the compose file, verify that the container is running normally.
- Run with the `docker compose up -d` command.

## ✍️ Authors

- Kim Kang Min (cgextra@daum.net)
