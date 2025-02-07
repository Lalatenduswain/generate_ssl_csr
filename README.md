# Generate SSL Certificate Signing Request (CSR) with OpenSSL

## Overview
This script automates the process of generating a private key and a Certificate Signing Request (CSR) using OpenSSL. The CSR is required when requesting an SSL certificate from a Certificate Authority (CA).

## Prerequisites
Before running this script, ensure you have the following:

- A Linux-based system (Ubuntu, Debian, CentOS, macOS, etc.)
- OpenSSL installed (`sudo apt install openssl` for Debian/Ubuntu or `sudo yum install openssl` for CentOS/RHEL)
- Proper permissions to execute the script (`chmod +x generate_ssl_csr.sh`)

## Installation & Usage

### Clone the Repository
```
git clone https://github.com/Lalatenduswain/generate_ssl_csr.git
cd generate_ssl_csr
```

### Running the Script
```
chmod +x generate_ssl_csr.sh
./generate_ssl_csr.sh
```

## Script Explanation
- **Generates a private key (`example_com.key`)**
- **Creates a CSR configuration file (`example_com.csr.cnf`)**
- **Generates a CSR (`example_com.csr`)**
- **Verifies the integrity of the public key using SHA-256**

## Disclaimer | Running the Script

**Author:** Lalatendu Swain | [GitHub](https://github.com/Lalatenduswain) | [Website](https://blog.lalatendu.info/)

This script is provided as-is and may require modifications or updates based on your specific environment and requirements. Use it at your own risk. The authors of the script are not liable for any damages or issues caused by its usage.

## Donations
If you find this script useful and want to show your appreciation, you can donate via [Buy Me a Coffee](https://www.buymeacoffee.com/lalatendu.swain).

## Support or Contact
Encountering issues? Don't hesitate to submit an issue on our [GitHub page](https://github.com/Lalatenduswain/generate_ssl_csr/issues).
