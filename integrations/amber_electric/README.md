# Amber Electric Integration

Disclaimer: I am a customer of [Amber Electric](https://mates.amber.com.au/FEH7HXNE), an Australian electricity provider that offers domestic energy users the wholesale national grid market price (that changes every 5 minutes) rather than 24/7 fixed plan rates (eg 32c/kWh).

Even though I dont have solar or battery, Amber Electric enables me to adapt or shift my energy use to take advantage of dynamic real-time energy prices and save significant money. I have a referral code for friends and family, no other financial incentive or promotions.

Even if you are not a customer with Amber Electric, the templates may provide some guidelines for you to customize to your energy provider.

## Features

My integration adds custom sensors for min and max prices, with price band color and descriptions so that I can make dashboards themed like the official Amber app.

The sensors use global variables and macros loaded from the `custom_templates` directory. These macros are loaded on Home Assistant start (or on call to the `reload custom jinja2 templates` service).

The dashboard uses the HACS modules 'mushroom' cards and 'apexcharts-card'.

### Gauge card

![](gauge_card.png)

### Forecast cards

It's good to know the current price, but will it get cheaper of more expensive later today? I use the 'mushroom template' card from HACS with my custom sensors to display the forecast min and max price over the next four hours.

![](forecast_cards.png)

### Apex Chart

I previously used the advanced Apex Chart integration from HACS to plot actual historical and forecast prices on one chart.

![](apex_chart.png)

My main dashboard for daily use is primarily focused on forecast prices only (I know they have high uncertainty). The historical price accuracy chart is displayed in a separate admin dashboard. 

## Installation

Install the official Amber Electric integration using the Settings UI.

Name the integration 'amber' so that entities are named `sensor.amber_general_price`, `sensor.amber_general_forecast`

The official Amber Electric sensors are in $/kWh to be compatible with the Energy dashboard cost estimates, but I prefer cents per kWh for normal dashboard cards and automations. My `electricity_price_sensor.yaml` will add a custom template sensor measured in c/kWh with price band label, description and colors.

The official Amber Electric mobile app modified the traffic light colors to reflect the average national energy price hikes in 2023, however I set my own price band thresholds because I want to define a 'neutral' based median price, rather than a 'normal' based average price skewed by evening peak prices. In my history statistics the median price is around 21 cents, not 32 cents. I feel anything over 26 cents / kWh should be considered high, anything over 36 cents is very high.

### Gauge Card

I use the 'gauge' card to show the current electricity price. The numbers here have to manually match the numbers in the `electricity_bands.jinja`, the gauge card does not support template values.

![](gauge_card.png)

``` yaml
type: gauge
entity: sensor.electricity_price
needle: true
segments:
  - from: -100
    color: '#4b0082'
  - from: 0
    color: '#03a9f4'
  - from: 6
    color: '#00e3a0'
  - from: 16
    color: '#ffc624'
  - from: 26
    color: '#fb8c0f'
  - from: 36
    color: '#dc2d20'
  - from: 66
    color: '#c920dc'
name: Electricity Price c/kWh
min: 0
max: 42
unit: 'c'
```

### Forecast cards

I use the 'mushroom template' card from HACS that enables me to display conditional states and properties from my custom Amber sensors.

![](forecast_cards.png)

``` yaml
type: custom:mushroom-template-card
primary: '{{ state_attr(entity,''label'') }}: {{ states(entity, with_unit=true) }}'
secondary: '{{ state_attr(entity,''description'') }}'
icon: '{{ state_attr(entity,''icon'') }}'
entity: sensor.electricity_price
icon_color: '{{ state_attr(entity,''color'') }}'
layout: horizontal
multiline_secondary: true
tap_action:
  action: more-info
```

Minimum price (next four hours)

``` yaml
type: custom:mushroom-template-card
primary: 'Min: {{ states(entity, with_unit=true) }}'
secondary: >-
  at {{ as_timestamp(state_attr(entity, 'forecast').start_time) |
  timestamp_custom("%H:%M") }} 
icon: mdi:clock
entity: sensor.electricity_forecast_4_hours_min
multiline_secondary: true
hold_action:
  action: none
double_tap_action:
  action: none
fill_container: false
icon_color: '{{ state_attr(entity,''color'') }}'
tap_action:
  action: more-info
badge_icon: mdi:arrow-down
```

Maximum price (next four hours)

```yaml
type: custom:mushroom-template-card
primary: 'Max: {{ states(entity, with_unit=true) }}'
secondary: >-
  at {{ as_timestamp(state_attr(entity, 'forecast').start_time) |
  timestamp_custom("%H:%M") }} 
icon: mdi:clock
entity: sensor.electricity_forecast_4_hours_max
multiline_secondary: true
hold_action:
  action: none
double_tap_action:
  action: none
fill_container: false
icon_color: '{{ state_attr(entity,''color'') }}'
tap_action:
  action: more-info
badge_icon: mdi:arrow-up
```

### Apex Chart

I use the advanced Apex Chart integration from HACS to plot actual historical and forecast prices. 

![](apex_chart.png)

``` yaml
type: custom:apexcharts-card
header:
  show: true
  title: Forecast Price
  show_states: true
  colorize_states: true
all_series_config:
  stroke_width: 1
  unit: c/kWh
  show:
    legend_value: false
    in_header: false
graph_span: 24h
span:
  offset: +24h
yaxis:
  - decimals: 0
series:
  - entity: sensor.amber_general_forecast
    name: Forecast
    color: '#039be5'
    stroke_width: 2
    curve: stepline
    data_generator: |
      return entity.attributes.forecasts.map((entry) => {
        return [new Date(entry.start_time), (entry.per_kwh * 100) ]  ;
      });
```
