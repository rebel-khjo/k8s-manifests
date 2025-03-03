openssl genrsa -des3 -out rootca.key 2048

openssl req -new -sha256 -key rootca.key -out rootca.csr

openssl x509 -req -sha256 -days 3650 -in rootca.csr -signkey rootca.key -out rootca.crt