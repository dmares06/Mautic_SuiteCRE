FROM php:8.2-apache

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    zip \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    mariadb-client \
    libpq-dev \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip \
    intl \
    gd \
    xml \
    mbstring \
    curl \
    opcache

# Set memory limit to fix OOM error
RUN echo "memory_limit = 768M" > /usr/local/etc/php/conf.d/99-custom.ini

# Enable Apache Rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy source code
COPY . .

# Increase Composer memory and install dependencies
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose HTTP port
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
