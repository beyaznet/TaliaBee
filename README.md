About
=====
The TaliaBee box is an easy-to-use I/O controller based on [Raspberry Pi](https://www.raspberrypi.org/) and [MedIOEx](http://www.samm.com/en/medioex-raspberry-pi-industrial-controller-card). This project contains the application layer of the TaliaBee box.

Table of contents
=================

- [About](#about)
- [Requirements](#requirements)
- [Installation](#installation)
- [Interfaces](#interfaces)
    - [Web user interface](#web-user-interface)
    - [Application programming interface (API)](#application-programming-interface)
    - [Python interface](#python-interface)

Requirements
============
- [Raspberry Pi 3 Model B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/)
- [MedIOEx Controller Card](http://www.samm.com/en/medioex-raspberry-pi-industrial-controller-card)
- [MedIOEx Switched-Mode Power Adaptor](http://www.samm.com/en/medioex-ms-4024-switched-mode-power-adaptor-24-volt-1-5-amper-smps)
- [Raspbian Jessie](https://www.raspberrypi.org/downloads/raspbian/) (fresh installed recommended)

Installation
============
```bash
wget https://raw.githubusercontent.com/beyaznet/TaliaBee/master/installer/install.sh
sudo bash install.sh
```

Interfaces
==========

### Web user interface
TaliaBee provides an easy-to-use, mobile-friendly web user interface.

![TaliaBee web interface](/doc/taliabeee_screen.png)

Please see the [GUI documentation](/doc/gui.md) for common usages.

### Application programming interface
TaliaBee provides an API for developers. The developers can monitor and control TaliaBee's I/O through API using their favorite programming languages. Therefore, you don't need to know a specific programming language to use TaliaBee. You can communicate through API even without writing any code.

Using `curl` to set the relay output #14
```bash
curl -s "http://127.0.0.1/api/ro/14/set"
```

Please see the [API documentation](https://github.com/beyaznet/TaliaBee/blob/master/doc/api.md) for common usages.

### Python interface
TaliaBee provides a Python interface for Pythonistas too. [Python TaliaBeeIO Module](https://github.com/beyaznet/python-taliabeeio-module) can be used to monitor and to control the I/O pins of the TaliaBee box through API.

```python
>>> from taliabeeio import TaliaBeeIO
>>> io = TaliaBeeIO()
>>>
>>> # read from the analog input 3
>>> print(io.ai3)
0
>>> # write to the analog output 4
>>> io.ao4 = 250
>>>
>>> # set the relay output 13
>>> io.ro13 = True
>>>
>>> # read the temperature
>>> print(io.temperature)
37.125
```

Please see [Python TaliaBeeIO Module](https://github.com/beyaznet/python-taliabeeio-module) project page for common usages.
