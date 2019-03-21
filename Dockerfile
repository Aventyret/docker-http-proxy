FROM codekitchen/dinghy-http-proxy

COPY local.cnf .
RUN openssl genrsa 2048 > local.docker.key 
RUN openssl req -new -x509 -nodes -sha1 -days 3650 -config local.cnf  -key local.docker.key > local.docker.crt 
RUN openssl x509 -noout -fingerprint -text < local.docker.crt > local.docker.info 
RUN cat local.docker.crt local.docker.key > local.docker.pem 
RUN chmod 400 local.docker.key local.docker.pem 

COPY start.sh .
RUN chmod 755 start.sh

CMD ["/app/start.sh"]
