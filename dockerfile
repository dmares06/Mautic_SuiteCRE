FROM php:8.2-apache

# Install required system packages and PHP extensions
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
    npm \
    curl \
    gnupg \
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

# 🔥 Increase PHP memory limit to fix "Allowed memory size" error
RUN echo "memory_limit = 768M" > /usr/local/etc/php/conf.d/99-memory-limit.ini

# Enable Apache Rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Run Composer with more memory and auto flags
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# Install NPM dependencies for Mautic assets
RUN npm ci || true

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose web server port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
