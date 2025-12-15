FROM php:8.4-apache

WORKDIR /var/www/html

RUN apt-get update 

RUN apt-get install -y \
    git \
    zip \
    curl \
    sudo \
    nano \
    cron \
    wget \
    zlib1g-dev \
    libzip-dev \
    libxml2-dev \
    unzip \
    libonig-dev \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++ \
    supervisor \
    iputils-ping \
    locales-all \
    locales

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.2.5

RUN apt-get install -y libpq-dev && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql 

RUN docker-php-ext-install pdo 
RUN docker-php-ext-install pdo_pgsql 
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install intl 
RUN docker-php-ext-install iconv 
RUN docker-php-ext-install bcmath 
RUN docker-php-ext-install opcache 
RUN docker-php-ext-install calendar 
RUN docker-php-ext-install mbstring 
RUN docker-php-ext-install zip 
RUN docker-php-ext-install mysqli 
RUN docker-php-ext-install gd 
RUN docker-php-ext-install gettext  

# RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*
# RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
#     && docker-php-ext-install imap

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

RUN apt-get update && apt-get install -y nodejs

RUN a2enmod rewrite

# RUN echo "* * * * * root php /var/www/html/artisan schedule:run >> /var/log/cron.log 2>&1" >> /etc/crontab

RUN touch /var/log/cron.log

RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# ADD configs/supervisord.conf /etc/supervisor/conf.d/worker.conf

RUN docker-php-ext-install pcntl

CMD ["sh","/var/www/html/entrypoint.sh","apache2-foreground"]

