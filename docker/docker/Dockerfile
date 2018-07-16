FROM ubuntu:16.04

RUN ["/bin/bash", "-c", " apt-get update && debconf-set-selections <<< 'mysql-server mysql-server/root_password password password' && debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password' && apt-get -y install mysql-server"]

RUN apt-get update
RUN apt-get -y install php php-cli php-mcrypt php-mysql php-xdebug php-gd php-mbstring php-dom php-zip php-imagick imagemagick php-curl curl tmux dialog vim wget git \
	&& useradd -m -d /home/mihail -s /bin/bash mihail \
	&& echo "[client]\nuser=root\npassword=password" > /root/.my.cnf \
	&& wget -O /root/composer-setup.php https://getcomposer.org/installer \
	&& php /root/composer-setup.php --install-dir=bin \
	&& mv /bin/composer.phar /bin/composer \
	&& rm /root/composer-setup.php

RUN apt-get -y install apache2 libapache2-mod-php

RUN apt-get -y install build-essential libsqlite3-dev ruby-dev

RUN gem install mailcatcher

RUN a2enmod rewrite
RUN sed -i 's/www-data/mihail/g' /etc/apache2/envvars
RUN echo "[mysqld]\ncharacter-set-server = utf8\ncollation-server = utf8_unicode_ci" > /etc/mysql/conf.d/charset.cnf
RUN echo "default-character-set = utf8" >> /root/.my.cnf
RUN usermod -d /var/lib/mysql mysql
RUN apt-get -y install msmtp
