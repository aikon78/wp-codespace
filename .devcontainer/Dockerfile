#FROM php:8.2.5-apache-bullseye
FROM mcr.microsoft.com/devcontainers/php:8-buster

#
# curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
# ReInstall Apache2
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y apache2 \
    && apt-get install -y php libapache2-mod-php php-mysql\ 
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

#RUN a2dismod ssl

# Install MariaDB client
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y mariadb-client \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="22"
#RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi
RUN su vscode -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash" 
#RUN su vscode -c "chmod +x /home/vscode/.nvm/nvm.sh"
#RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /home/vscode/.nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

#RUN su vscode -c "yes | ~/.nvm/npx playwright install-deps"  
#RUN su vscode -c "npx playwright install" 

EXPOSE 80