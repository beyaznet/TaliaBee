#!/usr/bin/python3

from taliabeeio import TaliaBeeIO
from time import sleep
from random import randrange

DELAY = 0.1

io = TaliaBeeIO()

try:
    while True:
        # reset
        io.reset()

        # read di
        for i in range(1,17,2):
            print('DI-%02d = %d' % (i, io.di_read(i)))
            sleep(DELAY)

        # read do
        for i in range(1,13,2):
            print('DO-%02d = %d' % (i, io.do_read(i)))
            sleep(DELAY)

        # set do
        for i in range(1,13):
            io.do_set(i)
            print('DO-%02d set' % (i))
            sleep(DELAY)

        # set relay / read relay
        for i in range(13,17):
            io.ro_set(i)
            print('RO-%02d set (%d)' % (i, io.ro_read(i)))
            sleep(DELAY)

        # read di
        for i in range(2,17,2):
            print('DI-%02d = %d' % (i, io.di_read(i)))
            sleep(DELAY)

        # read do
        for i in range(2,13,2):
            print('DO-%02d = %d' % (i, io.do_read(i)))
            sleep(DELAY)

        # reset do
        for i in range(12,0,-1):
            io.do_reset(i)
            print('DO-%02d reset' % (i))
            sleep(DELAY)

        # reset ro
        for i in range(16,12,-1):
            io.ro_reset(i)
            print('RO-%02d reset (%d)' % (i, io.ro_read(i)))
            sleep(DELAY)

        # write ao
        io.ao1 = randrange(0,4095)
        io.ao2 = randrange(0,4095)
        io.ao3 = randrange(0,4095)
        io.ao4 = randrange(0,4095)

        # read ai / ao
        print('AI-%02d = % 5d' % (1, io.ai1))
        print('AI-%02d = % 5d' % (2, io.ai2))
        print('AI-%02d = % 5d' % (3, io.ai3))
        print('AI-%02d = % 5d' % (4, io.ai4))

        print('A0-%02d = % 5d' % (1, io.ao1))
        print('A0-%02d = % 5d' % (2, io.ao2))
        print('A0-%02d = % 5d' % (3, io.ao3))
        print('A0-%02d = % 5d' % (4, io.ao4))

        # read temperature
        print('Temperature = %s' % (io.temperature))

        # status
        print('STATUS')
        print(io.status)
        print()

        # wait
        for i in range(20):
            v = i % 2
            io.ro_write(13, v)
            io.do_write(4, v)
            sleep(0.25)
except KeyboardInterrupt:
    io.reset()
