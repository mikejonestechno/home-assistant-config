# Home Assistant Config

[Home Assistant](https://www.home-assistant.io/) is an open source home automation that puts local control and privacy first. There are thousands of official and community supported integrations with a broad range of IoT devices.

## Source Config 

This is an experimental project for Home Assistant automation using the official Home Assistant Core (docker) image with MySQL Maria DB and Mosquitto MQTT broker.

## Getting Started

[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/mikejonestechno/home-assistant-config)

> If you already have VS Code and Docker installed, you can click the badge above to get started. Clicking this link will cause VS Code to automatically install the Dev Containers extension if needed, clone the source code into a container volume, and spin up a dev container for use.

1. Modify secrets.yaml to match your home location.

2. Open http://localhost:8123/ in a browser and start the onboarding setup to initialize your admin account and create the local database.

3. Go to http://localhost:8123/developer-tools/yaml and restart Home Assistant to reload the local configuration.yaml.