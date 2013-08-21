#!/bin/bash
myPath="/usr/development"

#dhcp

#vpn

#gitlab
#-------requirement---------------
if [ ! -d "$myPath" ]; then
  mkdir -p "$myPath"
fi
cd "$myPath"
chmod a+rwx "myPath"

#git
yes|apt-get install git
if [ $? -eq 0 ]; then
  echo "git installed success"
fi

#redis
wget -c http://redis.googlecode.com/files/redis-2.6.13.tar.gz
sleep 5
if [ -f redis-2.6.13.tar.gz]; then
  tar zxvf redis-2.6.13.tar.gz && mv redis-2.6.13 redis
else
  echo "redis download failed"
fi

#mysql
yes|apt-get install mysql-server
echo "qq"

#ruby 1.9.3
yes|apt-get install ruby1.9.3

# Install the Bundler Gem:
gem install bundler
##############################
while waiting for a long long time.You can try

sudo gem install bundler -p http://ruby.taobao.org/

##############################

#Create a git user for Gitlab:
adduser --disabled-login --gecos 'GitLab' git

# Login as git
sudo su git

# Go to home directory
cd /home/git

# Clone gitlab shell
git clone https://github.com/gitlabhq/gitlab-shell.git

cd gitlab-shell

# switch to right version
git checkout v1.3.0

cp config.yml.example config.yml

# Edit config and replace gitlab_url
# with something like 'http://domain.com/'
vim config.yml

# Do setup
./bin/install

#Database
mysql -u root -p"qq" << EOF
# Create a user for GitLab. (change $password to a real password)
CREATE USER 'gitlab'@'localhost' IDENTIFIED BY 'qq';

# Create the GitLab production database
CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;

# Grant the GitLab user necessary permissopns on the table.
GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'gitlab'@'localhost';

# Quit the database session
\q

# Try connecting to the new database with the new user
sudo -u git -H mysql -u gitlab -p -D gitlabhq_production
EOF

#-------------------gitlab---------------#
cd /home/git
# Clone GitLab repository
sudo -u git -H git clone https://github.com/gitlabhq/gitlabhq.git gitlab

# Go to gitlab dir
cd /home/git/gitlab

# Checkout to stable release
sudo -u git -H git checkout 5-1-stable

cd /home/git/gitlab

# Copy the example GitLab config
sudo -u git -H cp config/gitlab.yml.example config/gitlab.yml

# Make sure to change "localhost" to the fully-qualified domain name of your
# host serving GitLab where necessary
sudo -u git -H vim config/gitlab.yml

# Make sure GitLab can write to the log/ and tmp/ directories
sudo chown -R git log/
sudo chown -R git tmp/
sudo chmod -R u+rwX  log/
sudo chmod -R u+rwX  tmp/

# Create directory for satellites
sudo -u git -H mkdir /home/git/gitlab-satellites

# Create directories for sockets/pids and make sure GitLab can write to them
sudo -u git -H mkdir tmp/pids/
sudo -u git -H mkdir tmp/sockets/
sudo chmod -R u+rwX  tmp/pids/
sudo chmod -R u+rwX  tmp/sockets/

# Create public/uploads directory otherwise backup will fail
sudo -u git -H mkdir public/uploads
sudo chmod -R u+rwX  public/uploads

# Copy the example Puma config
sudo -u git -H cp config/puma.rb.example config/puma.rb


# Mysql----configure gitlab DB settings
sudo -u git cp config/database.yml.mysql config/database.yml
# Make sure to update username/password in config/database.yml.

#install gems
cd /home/git/gitlab

sudo gem install charlock_holmes --version '0.6.9.4'

####################################################################################
gem install bundler -p http://ruby.taobao.org/
sudo gem sources -a http://ruby.taobao.org/
gem source -u
sudo gem install bundle
sudo gem install bundler -p http://ruby.taobao.org/
sudo gem install charlock_holmes --version '0.6.9.4' -p http://ruby.taobao.org/
####################################################################################


# For MySQL (note, the option says "without")
sudo -u git -H bundle install --deployment --without development test postgres

#Initialise Database and Activate Advanced Features
sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production

#Download the init script (will be /etc/init.d/gitlab):)
sudo curl --output /etc/init.d/gitlab https://raw.github.com/gitlabhq/gitlabhq/master/lib/support/init.d/gitlab
sudo chmod +x /etc/init.d/gitlab

#Make GitLab start on boot:
sudo update-rc.d gitlab defaults 21

#Check Application Status

#Check if GitLab and its environment are configured correctly:

sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production
#To make sure you didn't miss anything run a more thorough check with:

sudo -u git -H bundle exec rake gitlab:check RAILS_ENV=production
#If all items are green, then congratulations on successfully installing GitLab! However there are still a few steps left.

#  Start Your GitLab Instance

  sudo service gitlab start
  # or
#  sudo /etc/init.d/gitlab restart

#Download an example site config:
sudo curl --output /etc/nginx/sites-available/gitlab https://raw.github.com/gitlabhq/gitlabhq/master/lib/support/nginx/gitlab
sudo ln -s /etc/nginx/sites-available/gitlab /etc/nginx/sites-enabled/gitlab

#Make sure to edit the config file to match your setup:
# Change **YOUR_SERVER_IP** and **YOUR_SERVER_FQDN**
# to the IP address and fully-qualified domain name
# of your host serving GitLab
sudo vim /etc/nginx/sites-available/gitlab

#restart
sudo service nginx restart

###Done!
###Visit YOUR_SERVER for your first GitLab login. The setup has created an admin account for you. You can use it to log in:
###
###admin@local.host
###5iveL!fe
###Important Note: Please go over to your profile page and immediately chage the password, so nobody can access your GitLab by using this login information later on.
###
###Enjoy!

######==============nginx.conf=================#########
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
#access_log  logs/access.log;
#pid        logs/nginx.pid;


events {
    use                 epoll;
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

upstream gitlab {
  server unix:/home/git/gitlab/tmp/sockets/gitlab.socket;
}
#server {
#  listen      80;
#  server_name phabricator.example.com;

#  root      /usr/development/facebook/phabricator/webroot;
#  try_files $uri $uri/ /index.php;

#  location / {
#    index   index.php;

#    if ( !-f $request_filename )
#    {
#      rewrite ^/(.*)$ /index.php?__path__=/$1 last;
#      break;
#    }
#  }

#  location /index.php {
#    fastcgi_pass   localhost:9000;
#    fastcgi_index   index.php;

    #required if PHP was built with --enable-force-cgi-redirect
#    fastcgi_param  REDIRECT_STATUS    200;

    #variables to make the $_SERVER populate in PHP
#    fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
#    fastcgi_param  QUERY_STRING       $query_string;
#    fastcgi_param  REQUEST_METHOD     $request_method;
#    fastcgi_param  CONTENT_TYPE       $content_type;
#    fastcgi_param  CONTENT_LENGTH     $content_length;

#    fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;

#    fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
#    fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

#    fastcgi_param  REMOTE_ADDR        $remote_addr;
#  }
#}

server {
  listen 80;                 # e.g., listen 192.168.1.1:80; In most cases *:80 is a good idea
  server_name localhost;     # e.g., server_name source.example.com;
  root /home/git/gitlab/public;     
  
  # individual nginx logs for this gitlab vhost
  access_log  /var/log/nginx/gitlab_access.log;
  error_log   /var/log/nginx/gitlab_error.log;
  
  location / {
    # serve static files from defined root folder;.
    # @gitlab is a named location for the upstream fallback, see below
    try_files $uri $uri/index.html $uri.html @gitlab;
  } 
  
  # if a file, which is not found in the root folder is requested,
  # then the proxy pass the request to the upsteam (gitlab unicorn)
  location @gitlab {
    proxy_read_timeout 300; # https://github.com/gitlabhq/gitlabhq/issues/694
    proxy_connect_timeout 300; # https://github.com/gitlabhq/gitlabhq/issues/694
    proxy_redirect     off;
    
    proxy_set_header   X-Forwarded-Proto $scheme;
    proxy_set_header   Host              $http_host;
    proxy_set_header   X-Real-IP         $remote_addr;
    
    proxy_pass http://gitlab;
  } 
}

}

####notes
####====http://www.vpsee.com/2012/11/install-gitlab-on-ubuntu-12-04/
