import urequests
import json
from machine import Pin

import time

import settings

YELLOW_LED_PIN = 21
GREEN_LED_PIN = 18
RED_LED_PIN = 19
BLUE_LED_PIN = 20


class BedLampRemote():
    def __init__(self):
        self.host = settings.host
        self.port = settings.port

        self.lamp_state = self.get_lamp_state()

        self.remote_state = "base"

        self.setup_LEDs()

        # now cycle thru the LEDs for power indication
        # first turn all of the leds off
        for col, led in self.leds_by_colour.items():
            self.set_led(col, "off")
        # then let's cycle through the LEDs
        for col, led in self.leds_by_colour.items():
            self.set_led(col, "on")
            time.sleep(0.5)
            self.set_led(col, "off")


    def setup_LEDs(self):
        self.yellow_led = Pin(settings.YELLOW_LED_PIN, Pin.OUT)
        self.green_led = Pin(settings.GREEN_LED_PIN, Pin.OUT)
        self.red_led = Pin(settings.RED_LED_PIN, Pin.OUT)
        self.blue_led = Pin(settings.BLUE_LED_PIN)

        self.leds_by_colour = {
            "yellow": self.yellow_led,
            "green": self.green_led,
            "red": self.red_led,
            "blue": self.blue_led
        }

    def set_led(self, led_colour, state):
        led = self.leds_by_colour[led_colour]
        if state == "on":
            led.value(1)
        elif state == "off":
            led.value(0)
        else:
            print("Invalid state")


    def get_lamp_state(self):
        hdrs = {'Content-Type': 'text/plain', 
                      'Accept': 'application/json'}


        #the_url = "{}:{}/GETLEVEL".format(self.host, self.port)
        
        the_url = self.host + "/GETLEVEL"

        print(the_url)
        # response = urequests.get(url=the_url, headers=hdrs)
        response = urequests.get(url=the_url)
        retdata = response.json()
        print(retdata)
        #return retdata[0]['RGB']
    
    def set_lamp_state(self, newcolour):


        cmd_data = {
                    "command":"SETALLCOLOUR",
                    "value":newcolour
                    }

        postdata = f"LAMP_COMMAND=|||{json.dumps(cmd_data)}|||"
        response = urequests.post(self.host,data = postdata)
        
        self.lamp_state = newcolour

        return
    


    

