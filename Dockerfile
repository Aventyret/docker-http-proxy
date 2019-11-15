FROM codekitchen/dinghy-http-proxy

COPY local.cnf .
RUN openssl genrsa 2048 > local.docker.key
RUN openssl req -new -x509 -nodes -sha1 -days 3650 -config local.cnf  -key local.docker.key > local.docker.crt
RUN openssl x509 -noout -fingerprint -text < local.docker.crt > local.docker.info
RUN cat local.docker.crt local.docker.key > local.docker.pem
RUN chmod 400 local.docker.key local.docker.pem
RUN sed -i'' 's|listen 80 default_server;|listen 80 default_server;listen 443 http2 ssl;ssl_protocols TLSv1 TLSv1.1 TLSv1.2;ssl_prefer_server_ciphers on;ssl_session_timeout 5m;ssl_session_cache shared:SSL:50m;ssl_certificate /etc/nginx/certs/local.docker.crt;ssl_certificate_key /etc/nginx/certs/local.docker.key;|g' /app/nginx.tmpl

COPY start.sh .
RUN chmod 755 start.sh

CMD ["/app/start.sh"]
