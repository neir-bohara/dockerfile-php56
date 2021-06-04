FROM php:5.6-fpm
LABEL maintainer="mrniranjanbohara@gmail.com"
# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libonig-dev \
    libzip-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    libsnmp-dev \
    libmcrypt-dev \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    openssl \
    telnet \
    snmp

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN docker-php-ext-install mysql mysqli gd
#RUN docker-php-ext-install mcryp
# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl snmp sockets
RUN docker-php-ext-configure gd  \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1008 www
RUN useradd -u 1008 -ms /bin/bash -g www www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
