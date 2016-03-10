FROM ubuntu
MAINTAINER Andrew Shankie <andrew@properdesign.rs>

# Credits go to https://github.com/eugeneware/docker-wordpress-nginx for most of the guts of this package
# And massive respect to @trickbooter http://trickbooter.com/ for shaping the overall idea

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

RUN apt-get update

RUN apt-get -y build-dep \
                  build-essential \
                  imagemagick

RUN apt-get -y install  \
                   curl \
                   git \
                   imagemagick \
                   memcached \
                   mysql-client \
                   nginx \
                   openssl \
                   php-apc \
                   php5-curl \
                   php5-fpm \
                   php5-gd \
                   php5-imap \
                   php5-imagick \
                   php5-intl \
                   php5-mcrypt \
                   php5-memcache \
                   php5-memcached \
                   php5-ming \
                   php-pear \
                   php5-ps \
                   php5-pspell \
                   php5-recode \
                   php5-sqlite \
                   php5-tidy \
                   php5-xmlrpc \
                   php5-xsl \
                   php5-mysql \
                   pwgen \
                   python-setuptools \
                   unzip

# nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# nginx site conf
ADD ./nginx-site.conf /etc/nginx/sites-available/default

WORKDIR /app


# Supervisor Config
RUN /usr/bin/easy_install supervisor
ADD ./supervisord.conf /etc/supervisord.conf

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp


# This is sometimes useful
RUN echo "export TERM=xterm" >> ~/.bash_aliases

# Add our scripts folder and make sure they're executable
ADD ./scripts /scripts
RUN chmod -R 755 /scripts

# Add some bits
ADD ./bits /bits

# private expose
EXPOSE 80 443

CMD ["/bin/bash", "/scripts/run.sh"]
