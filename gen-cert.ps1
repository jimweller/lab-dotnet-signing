openssl genrsa -out cert-ca.key 2048
openssl req -x509 -new -nodes -key cert-ca.key -sha256 -days 90 -out cert-ca.pem -subj '/C=US/ST=Ohio/L=Cityville/O=ExampleCo/OU=FCC/CN=ROOT CA'
openssl req -new -nodes -out cert.csr -newkey rsa:2048 -keyout cert.key -subj '/C=US/ST=Ohio/L=Cityville/O=ExampleCo/OU=FCC/CN=SIGNING CERT' -config csr.conf
openssl x509 -req -in cert.csr -CA cert-ca.pem -CAkey cert-ca.key -CAcreateserial -out cert.pem -days 90 -sha256 -extfile crt.conf
openssl pkcs12 -export -inkey cert-ca.key -in cert-ca.pem -out cert-ca.pfx -password pass:sign
openssl pkcs12 -export -inkey cert.key -in cert.pem -out cert.pfx -password pass:sign -certfile cert-ca.pem
Import-PfxCertificate -FilePath "cert-ca.pfx" -CertStoreLocation Cert:\LocalMachine\Root -Password (ConvertTo-SecureString -String "sign" -Force -AsPlainText)
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$pemContent = Get-Content -Path "cert.key" -Raw
$rsa.ImportFromPem($pemContent.ToCharArray())
$keyPair = $rsa.ExportCspBlob($true)
[System.IO.File]::WriteAllBytes("cert-key.snk", $keyPair)
