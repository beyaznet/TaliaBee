## ZigBee Interface

### Installing ZigBee interface

No additional installation needed.  Be sure you've installed the [web interface](../web) first.

### Running ZigBee interface

Go to `zigbee` folder inside the repository and run it as root.

```sh
cd 2017_proje_beyaz_taliabee/component/zigbee/home/pi/zigbee_interface
sudo python3 run.py
```

### How to use

In order to use ZigBee interface, you need to set your ZigBees to `API` mode.
And preferably, set your ZigBee Routers' `DL` and `DH` adresses to the broadcast adress of the network. (In order to use more than 2 ZigBees)

You will send a string and receive a string with the same format. The string should be in the format below:

`ID|TYPE|DATA`

Each field has a format, too.

#### `ID` Format

`ID` is an integer value between `0` and `9999`. This value is used to create request/response pairs.

#### `TYPE` Format

`TYPE` field specifies the data is a command or a reply for a command. `C` for command, `R` for reply.
There is no use of `R` while sending a command. You should probably use `C` value.

#### `DATA` Format

`DATA` is comma separated commands. The command types are below

- `DXXY`: Write `Y` to the `X`th digital output. `XX` is a right-aligned integer with two digits, `Y` is char `[0-1]`
- `RXXY`: Write `Y` to the `X`th relay output. `XX` is a right-aligned integer with two digits, `Y` is char `[0-1]`
- `AXXYYYY`: Write `YYYY` to the `XX`th analog output. `XX` is a right-aligned integer with two digits `[0-4]`, `YYYY` is a right-aligned integer with 4 digits `[0-4095]`
- `SZZ.Z`: Sleep for `ZZ.Z` seconds. (`S10.2` for example command means "sleep for 10.2 seconds")

### Response

For every sent command list (even if it's empty) values of the all I/O will be sent as response.
There is a format for that, too.

Format : `ID|R|dddddddddddddddd,DDDDDDDDDDDDRRRR,aaaa,AAAA,T`

- `d`: Digital Input. You'll see the status of a digital input here.
- `D`: Digital Output. You'll see the status of a digital output here.
- `R`: Relay Output. You'll see the status of a relay here.
- `a`: Analog Input. You'll see the status of a analog input here.
- `A`: Analog Output. You'll see the status of a analog output here.
- `T`: Temperature. You'll see a floating number here. (contains 5-6 characters)

Here you can see the the status of every single component.

### Examples

Here are the examples for the format:

> `9|C|R010001`

  This is the package with the id `9`

  This package contains commands.

  The command is `R011` means "Write 1 to relay output 1". (Set it)


> `9|R|0000000100000000,1000000000001000,1263345619821746,1000200030004000,-2.75`

  This is the response for the package with id = `9`

  This data contains a reply for your command list that you've sent before.

  All digital inputs are in `0000000100000000`.

  All digital outputs and relays are in `1000000000001000`.

  All analog inputs are in `1263345619821746`.

  First Analog Input is `1263`.

  Second Analog Input is `3456`.

  Third Analog Input is `1982`.

  Fourth Analog Input is `1746`.

  All analog outputs are in `1000200030004000`.

  Temperature is -2.75
