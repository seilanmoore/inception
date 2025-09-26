FROM debian:bookworm

RUN apt update -y && apt upgrade -y && \
    apt install -y nginx openssl gettext && \
    apt clean && rm -rf /var/lib/apt/lists/*

ARG DOMAIN_NAME

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes \
    -days 365 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/CN=${DOMAIN_NAME}"

RUN mkdir -p /var/www/wordpress /var/run/nginx && \
chmod 755 /var/www/wordpress && \
chown -R www-data:www-data /var/www/wordpress
    
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/nginx.sh /usr/local/bin/nginx.sh
RUN chmod +x /usr/local/bin/nginx.sh

ENTRYPOINT ["/usr/local/bin/nginx.sh"]
CMD ["nginx", "-g", "daemon off;"]
