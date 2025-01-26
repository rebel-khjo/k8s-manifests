# Password, Domain은 마음대로 지정하면 됩니다.
PASSWORD="gudokzomyo"
DOMAIN="bookinfo.beer1.com"

# CA 개인키 생성
$ openssl genrsa -passout "pass:$PASSWORD" -aes256 -out rootCA.key 2048

# CA Csr 생성
$ openssl req -new -key rootCA.key -subj "/cn=$DOMAIN" --addext "subjectAltName = DNS:$DOMAIN" -passin "pass:$PASSWORD" -passout "pass:$PASSWORD" -out rootCA.csr

# CA용 SAN 생성
$ echo "[ v3_ca ]
basicConstraints = critical,CA:TRUE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer:always

extendedKeyUsage = serverAuth,clientAuth
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = $DOMAIN" > san-ca.txt

# CA 공개키 생성
$ openssl x509 -req -days 365 -extensions v3_ca -set_serial 1 -in rootCA.csr --passin "pass:$PASSWORD" -signkey rootCA.key -out rootCA.crt -extfile san-ca.txt

# 서버 개인키 생성
$ openssl genrsa -passout "pass:$PASSWORD" -out server.key 2048

# 서버 CSR 생성
$ openssl req -new -key server.key -subj "/cn=$DOMAIN"  --addext "subjectAltName = DNS:$DOMAIN" -passin "pass:$PASSWORD" -passout "pass:$PASSWORD" -out server.csr

# 서버 SAN 생성
$ echo "[ v3_user ]
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = nonRepudiation, digitalSignature, keyEncipherment

extendedKeyUsage = serverAuth,clientAuth
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = $DOMAIN" > san.txt

# 서버 공개키 생성
$ openssl x509 -req -days 365 -extensions v3_user -in server.csr -passin "pass:$PASSWORD" -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out server.crt -extfile san.txt