FROM ubuntu:bionic
MAINTAINER "Hamdi AFRIT <hamdieaf@gmail.com>"

WORKDIR "/var/www"

ENV DOCKER_USER=www-data
# Fixes some weird terminal issues such as broken clear / CTRL+L
ENV TERM=linux
# Ensure apt doesn't ask questions when installing stuff
ENV DEBIAN_FRONTEND=noninteractive

# Install Ondrej repos for Ubuntu Bionic, PHP7.4, composer and selected extensions - better selection than
# the distro's packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" > /etc/apt/sources.list.d/ondrej-php.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        curl \
        git \
        nano \
        zip \
        unzip \
        php-apcu \
        php-apcu-bc \
        php7.4-cli \
        php7.4-curl \
        php7.4-json \
        php7.4-mbstring \
        php7.4-opcache \
        php7.4-readline \
        php7.4-xml \
        php7.4-zip \
        php7.4-fpm \
        php-pear \
        php7.4-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y install build-essential make nano apt-utils zlib1g-dev libpcre3-dev \
    && apt-get -y --no-install-recommends install php7.4-mysql php7.4-pgsql php7.4-intl php7.4-xmlrpc php-yaml php-xdebug php7.4-gd php7.4-xsl \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install XDEBUG
RUN pecl install xdebug

# Install Composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

# ADD SYMFONY INSTALLER
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony \
    && chmod a+x /usr/local/bin/symfony

# ACTIVATE XDEBUG && CUSTOM PHP.INI CONFIG
COPY config/xdebug-overrides.ini /etc/php/7.4/fpm/conf.d/99-xdebug.ini
COPY config/xdebug-overrides.ini /etc/php/7.4/cli/conf.d/99-xdebug.ini
COPY config/xdebug-overrides.ini /etc/php/7.4/mods-available/xdebug.ini
COPY config/overrides-php-fpm.ini /etc/php/7.4/mods-available/overrides-php-fpm.ini
COPY config/overrides-php-fpm.ini /etc/php/7.4/cli/conf.d/overrides-php-fpm.ini
RUN ln -s /etc/php/7.4/mods-available/overrides-php-fpm.ini /etc/php/7.4/fpm/conf.d/overrides-php-fpm.ini

# Enable XDEBUG
RUN phpdismod xdebug

# CUSTOMISE DOCKER SHELL FOR ROOT
COPY config/bash/.bashrc /root/.bashrc
COPY config/bash/.bash_prompt /root/.bash_prompt
COPY config/bash/.bash_logout /root/.bash_logout
COPY config/bash/.git-completion.bash /root/.git-completion.bash

# CUSTOMISE DOCKER SHELL FOR $DOCKER_USER
COPY config/bash/.bashrc /home/$DOCKER_USER/.bashrc
COPY config/bash/.bash_prompt /home/$DOCKER_USER/.bash_prompt
COPY config/bash/.bash_logout /home/$DOCKER_USER/.bash_logout
COPY config/bash/.git-completion.bash /home/$DOCKER_USER/.git-completion.bash

# PHP-FPM packages need a nudge to make them docker-friendly
COPY overrides.conf /etc/php/7.4/fpm/pool.d/z-overrides.conf

RUN usermod -u 1000 $DOCKER_USER

CMD ["php", "-a"]
CMD ["/usr/sbin/php-fpm7.4", "-O" ]

# Open up fcgi port
EXPOSE 9000
