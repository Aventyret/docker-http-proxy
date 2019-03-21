# docker-http-proxy

## 1 Prepare host resolver

```
sudo mkdir -p /etc/resolver/
cat << EOF | sudo tee /etc/resolver/docker
nameserver 127.0.0.1
port 19322
EOF
```

## Start docker http proxy container

```
docker run -d --restart=always \
  -v /var/run/docker.sock:/tmp/docker.sock:ro \
  -p 80:80 -p 443:443 -p 19322:19322/udp \
  -e DNS_IP=127.0.0.1 -e CONTAINER_NAME=http-proxy  \
  --name http-proxy \
  aventyret/docker-http-proxy
```

## Add certificate to Keychain (Mac)

```
docker cp  http-proxy:/etc/nginx/certs/local.docker.crt /tmp/
cd /tmp/
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/local.docker.crt
```

