# Amber Electric Integration

Disclaimer: I am a customer of [Amber Electric](https://mates.amber.com.au/FEH7HXNE), an Australian electricity provider that offers home users
the wholesale national grid price (changes every 5 min) rather than 24/7 fixed plan rates (eg 32c/kWh).

Even though I dont have solar or battery, Amber Electric enable me to shift my load to off peak periods and save money. I have a referral code for friends and family, no other financial incentive or promotions.

Even if you are not a customer with Amber Electric, the templates may provide some guidelines for you to customize to your energy provider.

## Features

My integration adds custom sensors for min and max prices, with price band color and descriptions so that I can make dashboards themed like the official Amber app.

### Gauge card

![](gauge_card.png)

### Forecast cards

It's good to know the current price, but will it get cheaper of more expensive later today? I use the 'mushroom template' card from HACS with my custom sensors to display the forecast min and max price over the next four hours.

![](forecast_cards.png)

### Apex Chart

I use the advanced Apex Chart integration from HACS to plot actual historical and forecast prices. This helps me plan ahead and understand how likely the forecast prices will actually be based on historical trends.

![](apex_chart.png)

## Installation

Install the official Amber Electric integration using the Settings UI.

Name the integration 'amber' so that entities are named sensor.amber_general_price, sensor.amber_general_forecast

My `amber_electric_sensor.yaml` will add custom template sensors since the official sensors are in $/kWh to be compatible 
with the Energy dashboard cost estimates, but I prefer cents per kWh for normal dashboard cards and automations.

The official app modified the traffic light colors to reflect national energy price hikes in 2023, however I set 
my own rate thresholds because in my history statistics the median price is around 21 cents, not 35 cents. I beleive anything over 26 cents / kWh should be considered normal, 35 cents is high.

### Gauge Card

I use the 'gauge' card to show the current electricity price. The numbers here have to manually match the numbers in the price band yaml, the gauge card does not support template values.

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
  - from: 46
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
primary: '{{ state_attr(entity,''band'').label }}: {{ states(entity, with_unit=true) }}'
secondary: '{{ state_attr(entity,''band'').description }}'
icon: '{{ state_attr(entity,''icon'') }}'
entity: sensor.electricity_price
icon_color: '{{ state_attr(entity,''band'').color }}'
layout: horizontal
multiline_secondary: true
```

Minimum price (next four hours)

``` yaml
type: custom:mushroom-template-card
primary: |-
  Min: {{ state_attr(entity,'4h').min.price | int }} {{ state_attr(entity,
    'unit_of_measurement') }}
secondary: >-
  at {{ as_timestamp(state_attr(entity, '4h').min.time) |
  timestamp_custom("%-I:%M %p") }} 
icon: mdi:clock
entity: sensor.electricity_forecast
multiline_secondary: true
hold_action:
  action: none
double_tap_action:
  action: none
fill_container: false
icon_color: '{{ state_attr(entity,''4h'').min.color }}'
tap_action:
  action: more-info
badge_icon: mdi:arrow-down
```

Maximum price (next four hours)

```yaml
type: custom:mushroom-template-card
primary: >-
  Max: {{ state_attr(entity,'4h').max.price | int }} {{ state_attr(entity,
  'unit_of_measurement') }}
secondary: >-
  at {{ as_timestamp(state_attr(entity, '4h').max.time) |
  timestamp_custom("%-I:%M %p") }} 
icon: mdi:clock
entity: sensor.electricity_forecast
multiline_secondary: true
tap_action:
  action: none
hold_action:
  action: none
double_tap_action:
  action: none
fill_container: true
icon_color: '{{ state_attr(entity,''4h'').max.color }}'
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
