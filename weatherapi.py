from pprint import pprint
import requests
from dotenv import load_dotenv, find_dotenv
from pathlib import Path
import os

load_dotenv(Path(".env"))
api_key = os.getenv("WEATHER_API")
base_url = 'https://api.weatherapi.com/v1'

def astronomy(location, date):
    endpoint = f'/astronomy.json?key={api_key}&q={location}&dt={date}'
    url = base_url + endpoint
    response = requests.get(url)
    data = response.json()
    pprint(data)

def forecast_weather(location, days, date, unixdt, hour, lang):
    endpoint = f'/forecast.json?key={api_key}&q={location}&days={days}&dt={date}&unixdt={unixdt}&hour={hour}&lang={lang}'
    url = base_url + endpoint
    response = requests.get(url)
    data = response.json()
    pprint(data)
    x = data['location']
    y = data['current']
    pprint(x)

    try:
        with open('media/location.txt', 'wt') as file:
            file.write(str(x))
    except:
        print("Unable to write to file")

    try:
        with open('media/attributes.txt', 'wt') as file:
            file.write(str(y))
    except:
        print("Unable to write to file")

    lat = x['lat']
    lng = x['lon']
    response = requests.get('https://api.stormglass.io/v2/bio/point', params={'lat': lat, 'lng': lng, 'params': 'soilMoisture'},
                            headers={'Authorization': 'f6088ca4-1674-11ee-86b2-0242ac130002-f6088d12-1674-11ee-86b2-0242ac130002'})

    json_data = response.json()
    # print(json_data)

    try:
        with open('media/full_info.txt', 'wt') as file:
            file.write(str(data) + str(json_data))
    except:
        print("Unable to write to file")

def future_weather(location, date, lang):
    endpoint = f'/forecast.json?key={api_key}&q={location}&dt={date}&lang={lang}'
    url = base_url + endpoint
    response = requests.get(url)
    data = response.json()
    pprint(data)

def realtime_weather(location, lang):
    endpoint = f'/current.json?key={api_key}&q={location}&lang={lang}'
    url = base_url + endpoint
    response = requests.get(url)
    data = response.json()
    pprint(data)

# Usage
q = 'vit chennai'
dt = '2023-07-06'
lang = 'lang_example'

astronomy(q, dt)
forecast_weather(q, 56, dt, 56, 56, lang)
future_weather(q, dt, lang)
realtime_weather(q, lang)