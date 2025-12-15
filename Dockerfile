FROM php:8.5-apache

WORKDIR /var/www/html

RUN apt-get update 

RUN apt-get install -y \
    zip \
    curl \
    sudo \
    nano \
    cron \
    wget \
    zlib1g-dev \
    libzip-dev \
    unzip \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++ \
    iputils-ping \
    supervisor

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.2.5

RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && docker-php-ext-install \
    bz2 \
    intl \
    iconv \
    bcmath \
    opcache \
    calendar \
    mbstring \
    zip \
    mysqli \
    gd \
    gettext 
    

# RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*
# RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
#     && docker-php-ext-install imap

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

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

