# Midterm
import machine
from machine import Pin, SoftI2C, PWM, ADC
import time
import neopixel
import math
import veml6040
import network
import espnow
button_Play = Pin(34, Pin.IN, Pin.PULL_UP)
button_Train = Pin(35, Pin.IN, Pin.PULL_UP)
np = neopixel.NeoPixel(machine.Pin(15), 2)
pin = machine.Pin(35, machine.Pin.IN, machine.Pin.PULL_UP)


# COLOR SENSING
i2c1 = SoftI2C(scl = Pin(22), sda = Pin(21))
# i2c2 = SoftI2C(scl = Pin(25), sda = Pin(26))
print(i2c1.scan())
# print(i2c2.scan())
lightsensor = ADC(Pin(33))


DEBOUNCE_MS = 200
last_press = 0

pressed_flag = False
STATE_PLAY = False
STATE_TRAIN = True

def playButton(p):
    global STATE_PLAY
    global STATE_TRAIN
    STATE_PLAY = True
    STATE_TRAIN = False

def trainButton(p):
    global pressed_flag
    global STATE_TRAIN
    STATE_TRAIN = True
    pressed_flag = True
  
button_Train.irq(trigger=Pin.IRQ_RISING, handler=trainButton)
button_Play.irq(trigger=Pin.IRQ_RISING, handler=playButton)



sensor2 = veml6040.VEML6040(i2c1)
sensor2.trigger_measurement

# sensor2 = veml6040.VEML6040(i2c2)
# sensor2.trigger_measurement


def k_nearest_neighbor(x,y,z, data, k = 7):
    distances = []
    for index, d in enumerate(data):
        dist = math.sqrt((x-d[0])**2+(y-d[1])**2+(z-d[2])**2)
        distances.append([dist,d[3]])
    
    distances.sort()
    distances = distances[:k] #get k distances
    classes = []
    for dist in distances:
        classes.append(dist[1])
#     print("k classes", classes)
    most_number_of_closest_classes = max(set(classes), key = classes.count)
#     print("max classes ", most_number_of_closest_classes)
    
    return most_number_of_closest_classes
# MOTOR CLASS
class Count(object):
    def __init__(self,A,B):
        self.A = Pin(A, Pin.IN)
        self.B = Pin(B, Pin.IN)
        self.counter = 0

        self.A.irq(self.cb,self.A.IRQ_FALLING|self.A.IRQ_RISING) #interrupt on line A
        self.B.irq(self.cb,self.B.IRQ_FALLING|self.B.IRQ_RISING) #interrupt on line B


    def cb(self,msg):
        other,inc = (self.B,1) if msg == self.A else (self.A,-1) #define other line and increment
        self.counter += -inc if msg.value()!=other.value() else  inc 
        
    def value(self):
        print(self.counter)
        return self.counter
class Motor(Count):
    def __init__(self,m1,m2, A, B):
        self.enc = Count(A,B)
        self.M1 = PWM(m1, freq=50, duty_u16=0)
        self.M2 = PWM(m2, freq=50, duty_u16=0)
        self.stop()
        
    def pos(self):
        print(self.enc.value())        
            
    def stop(self):
        self.M1.duty_u16(0) 
        self.M2.duty_u16(0) 

    def start(self, direction = 0, speed = 50):
        if direction:
            self.M1.duty_u16(int(speed*65535/100)) 
            self.M2.duty_u16(0)
        else:
            self.M1.duty_u16(0)
            self.M2.duty_u16(int(speed*65535/100))
            print("on")

 
def forward():
#     print("forward")
    Motor1.start(0, 25)
    Motor2.start(1, 25)
def soft_left():
#     print("soft left")
    Motor1.start(0, 10)
    Motor2.start(1, 50)
def soft_right():
#     print("soft right")
    Motor1.start(0, 50)
    Motor2.start(1, 10)
def hard_left():
#     print("soft left")
    Motor1.start(0, 50)
    Motor2.start(0, 50)
def hard_right():
#     print("soft right")
    Motor1.start(0, 50)
    Motor2.start(0, 50)
def stop():
#     print("soft right")
    Motor1.start(0, 0)
    Motor2.start(0, 0)  
    
    

#     esp32 now setup
# A WLAN interface must be active to send()/recv()
sta = network.WLAN(network.WLAN.IF_STA)  # Or network.WLAN.IF_AP
sta.active(True)
sta.disconnect()      # For ESP8266

e = espnow.ESPNow()
e.active(True)
peer = b'\x20\x50\x0d\x2b\x05\xf8'  # MAC address of peer's wifi interface
e.add_peer(peer)      # Must add_peer() before send()

Motor1 = Motor(14,27, 32,39) #first two are motor pins, last two are encoder pins
Motor2 = Motor(12,13, 33,32) #first two are motor pins, last two are encoder pins    
data1 = []
data2 = []
color = ""
index = 0
playing = 0
switch = 32000
redTrue = 0
blueTrue = 0
greenTrue = 0

while True:

    red1, green1, blue1, white1 = sensor2.read_rgbw()
#     red2, green2, blue2, white2 = sensor2.read_rgbw()
    if(STATE_TRAIN and pressed_flag):
        e.send(peer,'training')
        print(red1, green1, blue1, white1)
        index = index+1
        if index <= 1:
            for i in range(15):
                color = "black"
                data1.append((red1, green1, blue1, color))
#                 data2.append((red1, green1, blue1, color))
#                 data2.append((red2, green2, blue2, color))
                e.send(peer,'white')
                np[0] = [0, 0, 0]
                np[1] = [0, 0, 0]
                np.write()
                pressed_flag = False
        elif index >1 and index<=2:
            for i in range(15):
                color = "white"
                data1.append((red1, green1, blue1, color))
#                 data2.append((red1, green1, blue1, color))
#                 data2.append((red2, green2, blue2, color))
                np[0] = [255, 255, 255]
                np[1] = [255, 255, 255]
                np.write()
                e.send(peer,'red')
                pressed_flag = False
        elif index > 2 and index<= 3:
            for i in range(15):
                color = "red"
                data1.append((red1, green1, blue1, color))
                np[0] = [255, 0, 0]
                np[1] = [255, 0, 0]
                np.write()
#                 data2.append((red1, green1, blue1, color))
#                 data2.append((red2, green2, blue2, color))
                e.send(peer,'blue')
                pressed_flag = False
        elif index > 3 and index<= 4:
            for i in range(15):
                color = "blue"
                data1.append((red1, green1, blue1, color))
#                 data2.append((red1, green1, blue1, color))
#                 data2.append((red2, green2, blue2, color))
                np[0] = [0, 0, 255]
                np[1] = [0, 0, 255]
                np.write()
                e.send(peer,'green')
                pressed_flag = False
        elif index > 4 and index<= 5:
            for i in range(15):
                color = "green"
                data1.append((red1, green1, blue1, color))
#                 data2.append((red1, green1, blue1, color))
#                 data2.append((red2, green2, blue2, color))
                e.send(peer,'white')
                print("done with green")
                np[0] = [0, 255, 0]
                np[1] = [0, 255, 0]
                np.write()
                pressed_flag = False
        else:
            color = "no clue"

#         print(data1, data2)
# #   detection       
                
    if(STATE_PLAY):
        np[0] = [0, 0, 0]
        np[1] = [0, 0, 0]
        np.write()
        if redTrue == 0:
            if k_nearest_neighbor(red1, blue1, green1, data1, k = 7) == "red":
                stop()
                np[0] = [255, 0, 0]
                np[1] = [255, 0, 0]
                np.write()
                e.send(peer,'red')
                time.sleep(.5)
                np[0] = [0, 0, 0]
                np[1] = [0, 0, 0]
                np.write()
                redTrue = 1
        if blueTrue == 0:
            if k_nearest_neighbor(red1, blue1, green1, data1, k = 7) == "blue":
                stop()
                np[0] = [0, 0, 255]
                np[1] = [0, 0, 255]
                np.write()
                e.send(peer,'blue')
                time.sleep(.5)
                np[0] = [0, 0, 0]
                np[1] = [0, 0, 0]
                np.write()
                blueTrue = 1
        if greenTrue == 0:
            if k_nearest_neighbor(red1, blue1, green1, data1, k = 7) == "green":
                stop()
                np[0] = [0, 255, 0]
                np[1] = [0, 255, 0]
                np.write()
                e.send(peer,'green')
                time.sleep(.5)
                np[0] = [0, 0, 0]
                np[1] = [0, 0, 0]
                np.write()
                greenTrue = 1
        if lightsensor.read_u16() < switch:
    #         forward()
            soft_right()
            print("good")
        if lightsensor.read_u16() >= switch: #white
            print("help im confused")
            soft_left()

        time.sleep(.01)
        

            
        switch = switch + 0.001
        if switch > 40000:
            switch = 40000
        print(lightsensor.read_u16())




