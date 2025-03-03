openssl genrsa -des3 -out server.key 2048

openssl req -new -sha256 -key server.key -out server.csr

echo "
basicConstraints = critical, CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = DNS:beer1.com, DNS:*.beer1.com
" > server.conf

openssl x509 -req -days 3650 -extfile server.conf -CA rootca.crt -CAcreateserial -CAkey rootca.key -in server.csr -out server.crt