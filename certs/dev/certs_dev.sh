#!/bin/bash

script_name=$(basename "$0")

# Find the top-level git root (main project root, not submodule root)
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SECRETS_DIR="$PROJECT_ROOT/secrets/dev"
mkdir -p "$SECRETS_DIR"

create_step="++++++++++++ ✨ %s ++++++++++++\n"
validate_step="++++++++++++ ✅ %s ++++++++++++\n"

KEY_FILE="private.pem"
CERT_FILE="fullchain.pem"
DAYS_VALID=365
DOMAIN="localhost"

usage() {
    echo "usage: $script_name [-h]"
    echo "  -h      Display help"
}

generate_key_and_cert() {
    printf "$create_step" "Create $KEY_FILE and $CERT_FILE"
    openssl req -x509 -newkey rsa:4096 \
      -keyout "$SECRETS_DIR/$KEY_FILE" \
      -out "$SECRETS_DIR/$CERT_FILE" \
      -sha256 \
      -days $DAYS_VALID \
      -nodes \
      -subj "/CN=$DOMAIN"
}

validate_cert() {
    printf "$validate_step" "Validate $CERT_FILE"
    openssl x509 -text -in "$SECRETS_DIR/$CERT_FILE"
}

print_generated_files() {
    echo -e "📂 Generated files in: $SECRETS_DIR"
    files=("$KEY_FILE" "$CERT_FILE")
    for file in "${files[@]}"; do
        [ -f "$SECRETS_DIR/$file" ] && echo -e "   📄 $file"
    done
}

if [ $# -eq 0 ]; then
    generate_key_and_cert
    validate_cert
    print_generated_files
    exit 0
fi

while [ -n "$1" ]
do
  case "$1" in
    -h) usage; exit 0;;
    --) shift; break;;
  esac
  shift
done
