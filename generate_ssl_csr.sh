#!/bin/bash

# Define necessary variables
COUNTRY="US"
STATE="California"
LOCALITY="San Francisco"
ORG_NAME="Example Inc."
ORG_UNIT="IT Department"
COMMON_NAME="example.com"  # Change this to your actual domain
EMAIL="admin@example.com"

# Extract domain name dynamically (replace dots with underscores to avoid issues)
DOMAIN_NAME=$(echo "$COMMON_NAME" | tr '.' '_')

# Ensure required packages are installed
if ! command -v openssl &> /dev/null; then
    echo "Error: OpenSSL is not installed. Please install it using 'sudo apt install openssl' or the appropriate package manager."
    exit 1
fi

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

# Verify public key integrity
openssl pkey -in "${DOMAIN_NAME}.key" -pubout -outform pem | sha256sum
openssl req -in "${DOMAIN_NAME}.csr" -pubkey -noout -outform pem | sha256sum

echo "SSL CSR and Private Key generated successfully!"
echo "Private Key: ${DOMAIN_NAME}.key"
echo "CSR File: ${DOMAIN_NAME}.csr"
