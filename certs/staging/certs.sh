#!/bin/bash

script_name=$0

# Find the top-level git root (main project root, not submodule root)
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SECRETS_DIR="$PROJECT_ROOT/secrets/staging"
mkdir -p "$SECRETS_DIR"

usage() {
    echo "usage: $script_name [-rsh]"
    echo "  -r      Create Root CA"
    echo "  -s      Create SSL"
    echo "  -h      Display help"
}

create_step="++++++++++++ ✨ %s ++++++++++++\n"
validate_step="++++++++++++ ✅ %s ++++++++++++\n"

if [ $# -eq 0 ]; then
    usage
    exit 0
fi

rootca_key() {
    printf "$create_step" "Create rootca.key"
    openssl genrsa -aes256 -out "$SECRETS_DIR/rootca.key" 2048
    chmod 600 "$SECRETS_DIR/rootca.key"
}

rootca_csr() {
    printf "$create_step" "Create rootca.csr"
    openssl req -new \
        -key "$SECRETS_DIR/rootca.key" \
        -out "$SECRETS_DIR/rootca.csr" \
        -config rootca.conf
}

rootca_crt() {
    printf "$create_step" "Create rootca.crt"
    openssl x509 -req -days 3650 \
        -extensions v3_ca \
        -set_serial 1 \
        -in "$SECRETS_DIR/rootca.csr" \
        -signkey "$SECRETS_DIR/rootca.key" \
        -out "$SECRETS_DIR/rootca.crt" \
        -extfile rootca.conf
}

rootca_crt_validation() {
    printf "$validate_step" "Validate rootca.crt"
    openssl x509 -text -in "$SECRETS_DIR/rootca.crt"
}

ssl_key() {
    printf "$create_step" "Create $ssl_name.key"
    openssl genrsa -aes256 -out "$SECRETS_DIR/$ssl_name.key" 2048
    cp "$SECRETS_DIR/$ssl_name.key" "$SECRETS_DIR/$ssl_name.key.enc"
    printf "$create_step" "Enter the passphrase again to remove password from key"
    openssl rsa -in "$SECRETS_DIR/$ssl_name.key.enc" -out "$SECRETS_DIR/$ssl_name.key"
    chmod 600 "$SECRETS_DIR/$ssl_name.key"*
}

ssl_csr() {
    printf "$create_step" "Create $ssl_name.csr"
    openssl req -new \
        -key "$SECRETS_DIR/$ssl_name.key" \
        -out "$SECRETS_DIR/$ssl_name.csr" \
        -config ssl.conf
}

ssl_crt() {
    printf "$create_step" "Create $ssl_name.crt"
    openssl x509 -req -days 1825 \
        -extensions v3_user \
        -in "$SECRETS_DIR/$ssl_name.csr" \
        -CA "$SECRETS_DIR/rootca.crt" \
        -CAcreateserial \
        -CAkey "$SECRETS_DIR/rootca.key" \
        -out "$SECRETS_DIR/$ssl_name.crt" \
        -extfile ssl.conf
}

ssl_crt_validation() {
    printf "$validate_step" "Validate $ssl_name.crt"
    openssl x509 -text -in "$SECRETS_DIR/$ssl_name.crt"
}

print_generated_files() {
    echo -e "📂 Generated files in: $SECRETS_DIR"
    files=(rootca.key rootca.csr rootca.crt rootca.srl \
        "$ssl_name.key" "$ssl_name.key.enc" "$ssl_name.csr" "$ssl_name.crt")
    for file in "${files[@]}"; do
        if [ -n "$ssl_name" ]; then
            [[ "$file" == rootca.* || "$file" == *.srl ]] && continue
        else
            [[ "$file" == "$ssl_name.key" || "$file" == "$ssl_name.key.enc" || \
               "$file" == "$ssl_name.csr" || "$file" == "$ssl_name.crt" ]] && continue
        fi
        [ -f "$SECRETS_DIR/$file" ] && echo -e "   📄 $file"
    done
}

set -- $(getopt rs:h "$@")
while [ -n "$1" ]
do
  case "$1" in
    -r) [[ "$1" == -s ]] && exit 1
        rootca_key
        rootca_csr
        rootca_crt
        rootca_crt_validation
        print_generated_files;;
    -s) ssl_name=$2
          if [ -z "$ssl_name" ]
          then
            echo "You have to set ssl name"
            exit 1
          else
            sed -i "s/ssl_name/$ssl_name/g" ssl.conf
          fi
          ssl_key
          ssl_csr
          ssl_crt
          ssl_crt_validation
          print_generated_files
          sed -i "s/$ssl_name/ssl_name/g" ssl.conf;;
    -h) usage;;
    --) shift
          break;;
  esac
  shift
done
