FROM ubuntu:22.04

RUN apt update
RUN apt upgrade -y
RUN apt-get update && apt-get install -y ca-certificates
# Copy the certificate file into the container
COPY server.crt /usr/local/share/ca-certificates/

# Update CA certificates
RUN update-ca-certificates

# Set the certificate file path for curl
ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
RUN apt install -y curl git jq libicu70
RUN apt install -y openjdk-17-jdk

# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

RUN useradd agent
RUN chown agent ./
USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT ./start.sh