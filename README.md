# Azure DevOps Pipeline Self-Hosted Agent Docker Image

Welcome to my Azure DevOps Pipeline Self-Hosted Agent Docker Image repository! This Dockerfile sets up a self-hosted agent environment for Azure DevOps Pipelines with necessary dependencies and tools.

## Features

- **Base Image**: Ubuntu 22.04
- **Dependencies**:
  - PHP 8.1
  - Composer
  - SonarQube Scanner
  - Other necessary dependencies like curl, git, jq, unzip, etc.
- **Certificates**: Configures SSL certificates for secure connections.
- **Archiving**: Archives build artifacts into a ZIP file.
- **Entrypoint Script**: Sets up an entrypoint script for initialization.
- **Azure DevOps Pipeline Integration**: Pre-configured for seamless integration with Azure DevOps Pipelines.

## Usage

To build the Docker image, run:

```bash
docker build -t azure-devops-agent .

## For Usage via Docker Hub

## If you prefer to use the Docker image directly from Docker Hub, you can run the following command:

```bash
docker run -e AZP_URL=https://dev.azure.com/yourorganization/ \
           -e AZP_TOKEN="<Personal Access Token>" \
           -e AZP_POOL="<Agent Pool Name>" \
           -e AZP_AGENT_NAME="Docker Agent - Linux" \
           --name "azp-agent-linux" \
           ravikantchauhan/azure-self-hosted-agent:linux

