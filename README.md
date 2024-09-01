# Home Assistant Config

[Home Assistant](https://www.home-assistant.io/) is an open source home automation that puts local control and privacy first. There are thousands of official and community supported integrations with a broad range of IoT devices.

[![CI](https://github.com/mikejonestechno/home-assistant-config/actions/workflows/ci.yaml/badge.svg)](https://github.com/mikejonestechno/home-assistant-config/actions/workflows/ci.yaml) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=mikejonestechno_home-assistant-config&metric=alert_status)](https://sonarcloud.io/summary/overall?id=mikejonestechno_home-assistant-config) 

[GitHub Actions](https://github.com/mikejonestechno/home-assistant-config/actions/workflows/ci.yaml) trigger a devops CI pipeline on every PR and code quality is automatically scanned and published on [SonarCloud](https://sonarcloud.io/summary/overall?id=mikejonestechno_home-assistant-config). Although SonarQube can scan yaml files for code quality, the SonarCloud yaml quality profile does not include or apply any rules.

## Source Config 

This is an experimental project for Home Assistant automation using the official Home Assistant Core (docker) image.

## Integrations

### Amber Electric

My custom templates for the [Amber Electric](integrations/amber_electric/README.md) integration display electricity price forecasts for the next four hours. Even if you are not a customer with Amber Electric, the templates may provide some guidelines for you to customize to your energy provider.

![](integrations/amber_electric/gauge_card.png)
![](integrations/amber_electric/forecast_cards.png)

## Getting Started

1. Initially Home Assistant may activate 'safe mode' because the `secrets.yaml` is not defined in the github source project.

    ``` log
    ERROR (MainThread) [homeassistant.bootstrap] Failed to parse configuration.yaml:
    Secret home_latitude not defined. Activating safe mode
    ```

    The `init.sh` will create an example `secrets.yaml` file for you. Modify the properties in `secrets.yaml` to match your home location and timezone.

2. Open http://localhost:8123/ in a browser and start the onboarding setup to initialize your admin user account.

    The initial onboarding will prompt you for home location (default Amsterdam). The onboarding does not use the default configuration and `secrets.yaml` properties so skip the rest of the onboarding wizzard, supply a dummy fake address, and accept all the defaults for country, timezone and currency. 

4. Go to http://localhost:8123/developer-tools/yaml and restart Home Assistant to load the local configuration and `secrets.yaml`.