from machine import Pin, SPI, I2C
import time
from rotary_irq_rp2 import RotaryIRQ

from bedlamp_remote import BedLampRemote


###########################################################
###  Networking
###########################################################
import network
from wifi_secrets import ssid,password

if hasattr(network, "WLAN"):
    # the board has WLAN capabilities
    #Connect to WLAN
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    
    while not wlan.isconnected():
        wlan.connect(ssid, password, channel=8)
        # while wlan.status() < 0 or wlan.status() >= 3:
        print('Waiting for connection...')
        time.sleep(0.1)
    print('Connected!')
    print(wlan.ifconfig())





###########################################################
###  Constants
###########################################################
DEBOUNCE_SLEEP_TIME = 0.5 # in secs
MEM_SAVE_TIME = 2.0 #in secs

BUTTON_PRESSED = 0
BUTTON_RELEASED = 1


###########################################################
### Pin Definitions                                  ######
###########################################################
ROTARY_CLOCK_PIN = 3
ROTARY_DATA_PIN = 2

ON_BUTTON_PIN = 11
OFF_BUTTON_PIN = 10

MEM1_BUTTON_PIN = 12
MEM2_BUTTON_PIN = 13
MEM3_BUTTON_PIN = 14

COLOUR_BUTTON_PIN = 15

###########################################################
###               Remote                            #######
###########################################################

the_remote = BedLampRemote()




# ###########################################################
# ###               LEDs                              #######
# ###########################################################
# yellow_led = Pin(YELLOW_LED_PIN, Pin.OUT)
# green_led = Pin(GREEN_LED_PIN, Pin.OUT)
# red_led = Pin(RED_LED_PIN, Pin.OUT)
# blue_led = Pin(BLUE_LED_PIN, Pin.OUT)

# leds_by_colour = {
#     "yellow": yellow_led,
#     "green": green_led,
#     "red": red_led,
#     "blue": blue_led
# }

# def set_led(led_colour, state):
#     led = leds_by_colour[led_colour]
#     if state == "on":
#         led.value(1)
#     elif state == "off":
#         led.value(0)
#     else:
#         print("Invalid state")

##################################################
# first turn all of the leds off
# for col, led in leds_by_colour.items():
#     set_led(col, "off")
# # then let's cycle through the LEDs
# for col, led in leds_by_colour.items():
#     set_led(col, "on")
#     time.sleep(0.5)
#     set_led(col, "off")








 

###########################################################
###             Rotary Switch                       #######
###########################################################
BASE_VALUE = 0

# init the rotary switch
rotary = RotaryIRQ(pin_num_clk=ROTARY_CLOCK_PIN, 
        pin_num_dt=ROTARY_DATA_PIN, 
        min_val=0, 
        max_val=10000, 
        reverse=True, 
        range_mode=RotaryIRQ.RANGE_UNBOUNDED)
rotary.set(value=BASE_VALUE)

###########################################################

def rotary_listener():
    global rotary_val
    rotary_val = rotary.value()
    print("Rotary val={}".format(rotary_val))


rotary.add_listener(rotary_listener)

###########################################################
###########################################################
###          Buttons                               #######
###########################################################
###########################################################

on_button = Pin(ON_BUTTON_PIN, Pin.IN, Pin.PULL_DOWN)
off_button = Pin(OFF_BUTTON_PIN, Pin.IN, Pin.PULL_DOWN)
mem1_button = Pin(MEM1_BUTTON_PIN, Pin.IN, Pin.PULL_DOWN)
mem2_button = Pin(MEM2_BUTTON_PIN, Pin.IN, Pin.PULL_DOWN)
mem3_button = Pin(MEM3_BUTTON_PIN, Pin.IN, Pin.PULL_DOWN)
colour_button = Pin(COLOUR_BUTTON_PIN, Pin.IN, Pin.PULL_DOWN)



###########################################################
###           On and Off Buttons                    #######
###########################################################
def on_button_callback(p):
    # turn off irq while we are here
    on_button.irq(handler=None)

    print("on button pressed")
    time.sleep(DEBOUNCE_SLEEP_TIME)
    on_button.irq(trigger=Pin.IRQ_FALLING, handler=on_button_callback)

on_button.irq(trigger=Pin.IRQ_FALLING, handler=on_button_callback)

def off_button_callback(p):
    # turn off irq while we are here
    off_button.irq(handler=None)

    print("off button pressed")
    time.sleep(DEBOUNCE_SLEEP_TIME)
    off_button.irq(trigger=Pin.IRQ_FALLING, handler=off_button_callback)

off_button.irq(trigger=Pin.IRQ_FALLING, handler=off_button_callback)


###########################################################
###           Memory Buttons                       #######
###########################################################

mem_buttons = {
    1: mem1_button,
    2: mem2_button,
    3: mem3_button
}


def mem_button_handler(mem_num):
    """
    We will need a standard function to deal with the memory buttons
    """
    mem_button = mem_buttons[mem_num]

    print("mem button {} pressed".format(mem_num))
    
    time.sleep(DEBOUNCE_SLEEP_TIME)
    
    # when we are here then DEBOUNCE_SLEEP_TIME has elapsed
    start_time = time.ticks_ms()
    now = start_time
    long_press_time_end = start_time + ((MEM_SAVE_TIME*1000) - (DEBOUNCE_SLEEP_TIME*1000))
    #for i in range(0,10):
    while mem_button.value() == BUTTON_PRESSED:
        if now > long_press_time_end:
            print("detected LONG PRESS for MEM save")
            
            while mem_button.value() == BUTTON_PRESSED:
                time.sleep(0.1)
            print("end of long press")
        # get the time now    
        now = time.ticks_ms()
        
        

def mem1_button_callback(p):
    # turn off irq while we are here
    mem1_button.irq(handler=None)

    mem_button_handler(1)

    #time.sleep(DEBOUNCE_SLEEP_TIME)
    mem1_button.irq(trigger=Pin.IRQ_FALLING, handler=mem1_button_callback)

mem1_button.irq(trigger=Pin.IRQ_FALLING, handler=mem1_button_callback) 
    
    
def mem2_button_callback(p):
    # turn off irq while we are here
    mem2_button.irq(handler=None)

    mem_button_handler(2)

    #time.sleep(DEBOUNCE_SLEEP_TIME)
    mem2_button.irq(trigger=Pin.IRQ_FALLING, handler=mem2_button_callback)
    
mem2_button.irq(trigger=Pin.IRQ_FALLING, handler=mem2_button_callback)  
    

def mem3_button_callback(p):
    # turn off irq while we are here
    mem3_button.irq(handler=None)

    mem_button_handler(3)

    #time.sleep(DEBOUNCE_SLEEP_TIME)
    mem3_button.irq(trigger=Pin.IRQ_FALLING, handler=mem3_button_callback)
    
mem3_button.irq(trigger=Pin.IRQ_FALLING, handler=mem3_button_callback)






###########################################################
###           Colour Button                        #######
###########################################################

def colour_button_callback(p):
    # turn off irq while we are here
    colour_button.irq(handler=None)

    print("colour button pressed")
    time.sleep(DEBOUNCE_SLEEP_TIME)
    colour_button.irq(trigger=Pin.IRQ_FALLING, handler=colour_button_callback)
colour_button.irq(trigger=Pin.IRQ_FALLING, handler=colour_button_callback)


