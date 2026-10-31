#!/bin/bash

# --- DETECT PROJECT ROOT ---
# If running inside a VS Code workspace, use PWD; otherwise drop back one level from the script
if [ -d "$PWD/.vscode" ]; then
    PROJECT_PATH="$PWD"
else
    # Moves up one directory from where the script file resides
    PROJECT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

SSL_DIR="$PROJECT_PATH/src/assets/ssl"
SSL_CERT="$SSL_DIR/localhost.crt"
SSL_KEY="$PROJECT_PATH/assets/localhost.key" # Backed up outside src

# Create directories if they do not exist
mkdir -p "$SSL_DIR"

# --- GENERATE CERTIFICATE AND PRIVATE KEY ---
if [ ! -f "$SSL_CERT" ]; then
    echo "Generating a new self-signed certificate using OpenSSL..."
    
    # Generate both the certificate (.crt) and private key (.key) files instantly
    openssl req -x509 -newkey rsa:2048 -nodes -sha256 \
        -keyout "$SSL_DIR/localhost.key" \
        -out "$SSL_CERT" \
        -days 365 \
        -subj "/CN=localhost"
        
    echo "SSL files created successfully inside $SSL_DIR"

    # --- AUTOMATED WINDOWS IMPORT ---
    echo "Installing certificate into the Windows Trusted Root Store..."
    
    # Calls Windows' certutil engine to trust the file globally
    # Note: Path must use standard slashes, Windows handles it fine
    certutil.exe -addstore -f "Root" "$SSL_CERT"
    
    echo "Success! Windows and your browsers now fully trust localhost."
else
    echo "SSL certificate already exists and is configured."
fi

echo "SSL setup for $PROJECT_PATH is complete."
