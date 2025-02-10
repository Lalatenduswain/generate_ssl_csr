#!/bin/bash

# Define variables
COUNTRY="IN"
STATE="ODISHA"
LOCALITY="CTC"
ORG_NAME="Fine9"
ORG_UNIT="Web Development"
COMMON_NAME="lalatendu.info"  # Change this to match your domain
EMAIL="admin@lalatendu.info"

# Extract domain name dynamically (replace dots with underscores to avoid issues)
DOMAIN_NAME=$(echo "$COMMON_NAME" | tr '.' '_')

echo "Choose an option:"
echo "1) Generate CSR"
echo "2) Create a self-signed certificate (1 year)"
echo "3) Verify private key, CSR, and certificate match"
read -p "Enter your choice [1-3]: " CHOICE

case $CHOICE in
  1)
    echo "Generating CSR..."
    
    # Generate private key
    openssl genpkey -algorithm RSA -out "${DOMAIN_NAME}.key" -pkeyopt rsa_keygen_bits:2048

    # Create CSR configuration file
    cat > "${DOMAIN_NAME}.csr.cnf" <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
C = $COUNTRY
ST = $STATE
L = $LOCALITY
O = $ORG_NAME
OU = $ORG_UNIT
CN = $COMMON_NAME
emailAddress = $EMAIL
EOF

    # Generate CSR
    openssl req -new -key "${DOMAIN_NAME}.key" -out "${DOMAIN_NAME}.csr" -config "${DOMAIN_NAME}.csr.cnf"

    echo "CSR and private key generated successfully!"
    ;;

  2)
    echo "Creating a self-signed certificate for 1 year..."
    
    # Generate private key (if not exists)
    if [ ! -f "${DOMAIN_NAME}.key" ]; then
      openssl genpkey -algorithm RSA -out "${DOMAIN_NAME}.key" -pkeyopt rsa_keygen_bits:2048
    fi

    # Generate self-signed certificate (valid for 365 days)
    openssl req -x509 -new -nodes -key "${DOMAIN_NAME}.key" -sha256 -days 365 -out "${DOMAIN_NAME}.crt" -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORG_NAME/OU=$ORG_UNIT/CN=$COMMON_NAME/emailAddress=$EMAIL"

    echo "Self-signed certificate created: ${DOMAIN_NAME}.crt"
    ;;

  3)
    echo "Checking if private key, CSR, and certificate match..."

    if [[ ! -f "${DOMAIN_NAME}.key" || ! -f "${DOMAIN_NAME}.csr" || ! -f "${DOMAIN_NAME}.crt" ]]; then
      echo "Error: Missing key, CSR, or certificate files!"
      exit 1
    fi

    # Check if private key matches CSR
    KEY_MD5=$(openssl rsa -noout -modulus -in "${DOMAIN_NAME}.key" | openssl md5)
    CSR_MD5=$(openssl req -noout -modulus -in "${DOMAIN_NAME}.csr" | openssl md5)

    if [[ "$KEY_MD5" == "$CSR_MD5" ]]; then
      echo "✔ Private key matches CSR"
    else
      echo "❌ Private key does NOT match CSR"
    fi

    # Check if private key matches certificate
    CERT_MD5=$(openssl x509 -noout -modulus -in "${DOMAIN_NAME}.crt" | openssl md5)

    if [[ "$KEY_MD5" == "$CERT_MD5" ]]; then
      echo "✔ Private key matches certificate"
    else
      echo "❌ Private key does NOT match certificate"
    fi

    # Check if CSR matches certificate
    if [[ "$CSR_MD5" == "$CERT_MD5" ]]; then
      echo "✔ CSR matches certificate"
    else
      echo "❌ CSR does NOT match certificate"
    fi
    ;;

  *)
    echo "Invalid option! Exiting."
    exit 1
    ;;
esac
