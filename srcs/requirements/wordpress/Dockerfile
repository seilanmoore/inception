FROM debian:bookworm

RUN apt update -y && apt upgrade -y && \
		apt install -y curl php php-fpm php-mysql mariadb-client && \
		apt clean && rm -rf /var/lib/apt/lists/*

# COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY conf/www.conf /tmp/www.conf

RUN PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;') && \
	mv /tmp/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

COPY tools/wordpress.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh

CMD ["/usr/local/bin/wordpress.sh"]
