#Add custom Dockerfile for Railway deployment
FROM php:8.1-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    zip \
    libmcrypt-dev \
    mariadb-client \
    libpq-dev \
    && docker-php-ext-install pdo pdo_mysql zip intl gd xml mbstring curl

# Set PHP memory limit (🔥 THIS FIXES YOUR ERROR)
RUN echo "memory_limit = 768M" > /usr/local/etc/php/conf.d/99-override-memory.ini

# Enable Apache Rewrite Module
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy all files
COPY . /var/www/html

# Install Mautic dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose HTTP port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
