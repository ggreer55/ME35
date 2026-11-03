import network
import espnow
import time
import neopixel
import machine
from machine import Pin
np = neopixel.NeoPixel(machine.Pin(15), 2)
# A WLAN interface must be active to send()/recv()
sta = network.WLAN(network.WLAN.IF_STA)
sta.active(True)
sta.disconnect()   # Because ESP8266 auto-connects to last Access Point

e = espnow.ESPNow()
e.active(True)

mac_addresses = []
  
def recv_cb(esp):
    if esp.any():
        mac, msg = esp.irecv(0)  # Read immediate message buffer
        if mac is not None:
            print(mac, msg)
#             
    if msg == 'red':
        np[0] = (255, 0, 0)
        np[1]  = (255, 0, 0)
        np.write()
    elif msg == "black":
        np[0] = (0, 0, 0)
        np[1]  = (0, 0, 0)
        np.write()
    elif msg == "blue":
        np[0] = (0, 0, 255)
        np[1]  = (0, 0, 255)
        np.write()
    elif msg == "green":
        np[0] = (0, 255, 0)
        np[1]  = (0, 255, 0)
        np.write()
    elif msg == "white":
        np[0] = (255, 255, 255)
        np[1]  = (255, 255, 255)
        np.write()
        
while True:
    e.irq(recv_cb)
#     print(e.irq(recv_cb))
    time.sleep(.1)





