FROM ubuntu


RUN apt update && apt upgrade -y
RUN apt install -y netcat-openbsd nmap tcpdump dnsutils iputils-ping curl nano
RUN apt install -y python3 python3-pip
RUN apt install -y zip git \
    libfreetype6-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libonig-dev \
    netcat-traditional
RUN apt install -y php composer \
    php-mysqli \
    php-mbstring \
    php-xml \
    php-curl
RUN apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/www/composer
COPY ./composer.json /var/www/composer/composer.json
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --working-dir=/var/www/composer

RUN chown -R www-data:www-data /var/www/html
