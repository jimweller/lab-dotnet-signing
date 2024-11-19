#!/bin/sh


# CA
openssl genrsa -out cert-ca.key 2048
openssl req -x509 -new -nodes -key cert-ca.key -sha256 -days 90 -out cert-ca.pem -subj '/C=US/ST=Ohio/L=Cityville/O=ExampleCo/OU=FCC/CN=ROOT CA'

# Code signing
openssl req -new -nodes -out cert.csr -newkey rsa:2048 -keyout cert.key -subj '/C=US/ST=Ohio/L=Cityville/O=ExampleCo/OU=FCC/CN=SIGNING CERT' -config csr.conf
openssl x509 -req -in cert.csr -CA cert-ca.pem -CAkey cert-ca.key -CAcreateserial -out cert.pem -days 90 -sha256 -extfile crt.conf -copy_extensions=copyall

# convert to pkcs12/p12/pfx bundle for windows
openssl pkcs12 -legacy -export -inkey cert.key -in cert.pem -out cert.pfx -password pass:sign -certfile cert-ca.pem




# Install CA cert for mono on linux/mac
# sudo apt install -y ca-certificates
# sudo cp $CANAME.crt /usr/local/share/ca-certificates
# sudo update-ca-certificates

# find openssl cert store
# openssl version -d

# print PEM cert
# openssl x509 -in cert.pem -noout -text

# print p12 cert
# openssl pkcs12 -info -in cert.pfx

