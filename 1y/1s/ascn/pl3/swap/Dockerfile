FROM ubuntu:18.04

# install PHP, as required by the application, by using the following commands
RUN sudo add-apt-repository ppa:ondrej/php
RUN sudo apt update
RUN sudo apt install php7.4 php7.4-{fpm,zip,mbstring,tokenizer,mysql,gd,xml,bcmath,intl,curl}

# Install remaining dependencies (NodeJS, Composer and npm)
RUN sudo apt install nodejs
RUN sudo apt install composer
RUN sudo apt install npm

# 
RUN wget https://github.com/Hackathonners/swap/archive/refs/heads/master.zip
RUN sudo apt install unzip
RUN unzip master.zip 
RUN rm master.zip

