# CERTS

## 📃 Description

- This project generates private certificates used to enable TLS across internal applications.
- Separate automated scripts are provided for development and staging (production-like) environments.
- Due to the sensitivity of certificate lifecycle operations, creation and maintenance are restricted to a single designated operator.
- This project is intended to be used as a Git submodule.

## 📑Table of Contents

- [Dependencies](#-dependencies)
- [Usage](#-usage)
- [Tests](#-tests)

## 🔗 Dependencies

- openssl

## 👨‍💻 Usage

- When generating CSR/CRT files for the staging (production-like) environment, use the corresponding `*.conf` configuration files.
- Adjust the configuration files as required by your environment.

### 1. Development environment

```
cd ./dev
./certs_dev.sh
```

- Generates `fullchain.pem` and `private.pem`.
- The private key (`private.pem`) is created without a passphrase (development convenience).

### 2. Staging / Production-like environment

```
cd ./staging
./certs.sh -h
usage: ./certs.sh [-rh] [-s ssl_name]
  -r              Create Root CA
  -s ssl_name     Create SSL certificate with specified name
  -h              Display help
```

- Modify `rootca.conf` appropriately before creating the root CSR/CRT.
- Reusing an existing root certificate is recommended; avoid unnecessary re-issuance.
- Modify `ssl.conf` before generating a server CSR/CRT.
- Running `./certs.sh -s test` generates a server certificate named `test`.
- Both an encrypted key (`test.key.enc`) and an unencrypted key (`test.key`) are produced.

## 🧪 Tests

- Basic validation steps are embedded inside `certs.sh` during execution.

## ✍️ Authors

- Kim Kang Min (cgextra@daum.net)

## ⚖️ License

- Distributed under the MIT License. See the LICENSE file for details.
