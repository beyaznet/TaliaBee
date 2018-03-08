#!/usr/bin/python3

from serial import Serial
from taliabeez import TaliaBeeZ

if __name__ == '__main__':
    serial_port = Serial('/dev/ttyUSB0', 115200)
    m = TaliaBeeZ(serial_port)
    m.run()
