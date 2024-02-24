# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Update and install necessary dependencies
RUN apt update && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates \
    curl \
    git \
    jq \
    libicu70 \
    php \
    php-cli \
    unzip \
    php-xml \
    php-gd \
    openjdk-17-jdk \
    zip && \
    rm -rf /var/lib/apt/lists/*

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install SonarQube Scanner
RUN curl -sSLo /tmp/sonar-scanner-cli.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip && \
    unzip /tmp/sonar-scanner-cli.zip -d /opt && \
    mv /opt/sonar-scanner-4.6.2.2472-linux /opt/sonar-scanner && \
    ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm /tmp/sonar-scanner-cli.zip

# Set PHP version
ARG phpVersion=8.1
RUN ln -sf /usr/bin/php${phpVersion} /usr/bin/php \
    && ln -sf /usr/bin/phar${phpVersion} /usr/bin/phar \
    && ln -sf /usr/bin/phar.phar${phpVersion} /usr/bin/phar.phar \
    && ln -sf /usr/bin/phpdbg${phpVersion} /usr/bin/phpdbg

# Set the certificate file into the container
COPY server.crt /usr/local/share/ca-certificates/

# Update CA certificates
RUN update-ca-certificates

# Set the certificate file path for curl
ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# Set the working directory
WORKDIR /app

# Copy project files
COPY . .

# Install project dependencies using Composer
RUN composer install --no-interaction --prefer-dist || echo "Composer install failed. Check if composer.json exists."


# Archive build artifacts
RUN zip -r /app/build.zip . || echo "Zip command failed."

# Set the entrypoint script
ENV TARGETARCH="linux-x64"
COPY start.sh /azp/
RUN chmod +x /azp/start.sh
WORKDIR /azp/
RUN useradd agent
RUN chown agent ./

RUN mkdir -p /home/agent/.sonar/cache && chown -R agent:agent /home/agent/.sonar
USER agent

ENTRYPOINT ["./start.sh"]
