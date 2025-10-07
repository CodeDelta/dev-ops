# Reverse Proxy

## 📃 Description

Sample Nginx Reverse Proxy project that exposes internal services (e.g., GitLab, Nexus) through a single endpoint.  
All security‑sensitive or production‑specific details have been removed for portfolio purposes.

## 📑Table of Contents

- [Dependencies](#-dependencies)
- [Features](#-features)
- [Usage](#-usage)

## 🔗 Dependencies

- nginx
- docker (Docker Compose v2)

## ✨ Features

- Multiple upstream path-based routing (e.g., /gitlab, /nexus)
- HTTP → HTTPS redirection pattern
- Supports both self-signed and public CA certificates (works with the certs project)
- Single docker compose up for deployment
- Modular conf.d structure for easy extension

## 👨‍💻 Usage

#### 1. Prepare directory

```
mkdir -p ssl
```

#### 2. Place certificates

Self-signed / local test (using certs project):

```
cd ../certs/staging
./certs.sh
# Copy generated artifacts to:
../reverse_proxy/ssl/fullchain.pem
../reverse_proxy/ssl/privkey.pem
```

Public CA certificates should use the same target paths:

```
reverse_proxy/ssl/fullchain.pem
reverse_proxy/ssl/privkey.pem
```

#### 3. Start container

```
docker compose up -d
docker compose logs -f
```

If using a self-signed certificate, an initial browser trust warning is expected.

#### 4. Stop

```
docker compose down
```

## ✍️ Authors

- Kim Kang Min (cgextra@daum.net)
