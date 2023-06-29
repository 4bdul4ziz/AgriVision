from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint
import requests


configuration = swagger_client.Configuration()
configuration.api_key['key'] = '6eb9d101698a47a49db72950230706'

api_instance = swagger_client.APIsApi(swagger_client.ApiClient(configuration))
q = 'vit chennai'
dt = '2023-07-06' 

try:
    # Astronomy API
    api_response = api_instance.astronomy(q, dt)
    #pprint(api_response)
except ApiException as e:
    print("Exception when calling APIsApi->astronomy: %s\n" % e)

def test_weather(location,date):
    
    api_instance = swagger_client.APIsApi(swagger_client.ApiClient(configuration))
    q = location
    days = 56 
    dt = date 
    unixdt = 56 
    hour = 56 
    lang = 'lang_example' 

    try:
        # Forecast API
        api_response = api_instance.forecast_weather(q, days, dt=dt, unixdt=unixdt, hour=hour, lang=lang)
        pprint(api_response)
        x = api_response.location
        y = api_response.current
        pprint(x)

    except ApiException as e:
        print("Exception when calling APIsApi->forecast_weather: %s\n" % e)

    try:
        geeky_file = open('/Users/aman/AgriVision/media/location.txt', 'wt')
        geeky_file.write(str(x))
        geeky_file.close()
    
    except:
        print("Unable to write to file")

    try:
        geeky_file = open('/Users/aman/AgriVision/media/attributes.txt', 'wt')
        geeky_file.write(str(y))
        geeky_file.close()
    
    except:
        print("Unable to write to file")

    
    lat= api_response.location.lat
    lng= api_response.location.lon
    response = requests.get('https://api.stormglass.io/v2/bio/point',params={'lat': lat,'lng': lng ,'params': 'soilMoisture'}, 
                            headers={'Authorization': 'f6088ca4-1674-11ee-86b2-0242ac130002-f6088d12-1674-11ee-86b2-0242ac130002'})

    json_data = response.json()
    #print(json_data)

    try:
        geeky_file = open('/Users/aman/AgriVision/media/full_info.txt', 'wt')
        geeky_file.write(str(api_response)+str(json_data))
        geeky_file.close()
    
    except:
        print("Unable to write to file")





api_instance = swagger_client.APIsApi(swagger_client.ApiClient(configuration))
q = 'VIT Chennai' 
dt = '2023-08-08' 
lang = 'lang_example' 

try:
    # Future API
    api_response = api_instance.future_weather(q, dt=dt, lang=lang)
    #pprint(api_response)
except ApiException as e:
    print("Exception when calling APIsApi->future_weather: %s\n" % e)








api_instance = swagger_client.APIsApi(swagger_client.ApiClient(configuration))
q = 'vit chennai'
lang = 'lang_example' 
try:
    # Realtime API
    api_response = api_instance.realtime_weather(q, lang=lang)
   # pprint(api_response)
except ApiException as e:
    print("Exception when calling APIsApi->realtime_weather: %s\n" % e)

