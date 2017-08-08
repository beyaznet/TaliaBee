## Web Interface

The web interface contains no HTML templates. Just a simple API.

All endpoints implemented as a `GET` request. So you can use `curl` to test it quickly.

### Installing web interface
Clone the repository
```sh
git clone git@github.com:nejdetckenobi/medioex_interfaces.git
```

Go to `web` folder inside the repository.
```sh
cd medioex_interfaces/web
```

Run the installation script as root. That will download the required libs and install them.
```sh
sudo ./install.sh
```

### Running web interface

Go to `web` folder inside the repository and run it as root.

```sh
cd medioex_interfaces/web
sudo python3 run.py
```

### How to use

The interface contains 6 endpoints

- `/api/ai/<int:pin>/read`: This endpoint reads values from Analog Inputs.

- `/api/ao/<int:pin>/write`: This endpoint writes to Analog Outputs.
- `/api/ao/<int:pin>/read`: This endpoint reads values from Analog Outputs.
- `/api/ao/<int:pin>/set`: This endpoint writes '1' values from Analog Outputs.
- `/api/ao/<int:pin>/reset`: This endpoint writes '0' values from Analog Outputs.

- `/api/do/<int:pin>/write`: This endpoint writes to Digital Outputs.
- `/api/do/<int:pin>/read`: This endpoint reads values from Digital Outputs.
- `/api/do/<int:pin>/set`: This endpoint writes '1' values from Digital Outputs.
- `/api/do/<int:pin>/reset`: This endpoint writes '0' values from Digital Outputs.

- `/api/ro/<int:pin>/read`: This endpoint reads values from Relay Outputs.
- `/api/ro/<int:pin>/write`: This endpoint writes to Relay Outputs.
- `/api/ro/<int:pin>/set`: This endpoint writes '1' to Relay Outputs.
- `/api/ro/<int:pin>/reset`: This endpoint writes '0' to Relay Outputs.

- `/api/status`: This endpoint reads everything.
- `/api/reset`: This endpoint writes '0' to all Outputs.

- `/api/temperature/read`: This endpoint reads from the default temperature sensor on MedIOEx. Gives floating value. (Celsius)

These endpoints accepts the parameters below:

- `pin`: `[1-4]` for Analog Outputs and Analog Inputs, `[1-12]` for Digital Outputs, `[13-16]` for Relay  Outputs, `[1-16]` for Digital Inputs.

- `val`: `[0-1]` for Digitals, `[0-4095]` for Analogs.

**Note**: `val` parameter is only for writing purposes. All endpoints return JSON.

### Quick Examples

Assume that your RaspberryPi's IP address is `192.168.1.23` and you're running the web interface with the port `5000`


Writing `0` to Digital Output `1`

`curl "192.168.1.23:5000/api/do/1/write?val=0"`

Reading from Digital Input 3

`curl "192.168.1.23:5000/api/di/3/write"`

Reading from Analog Input 2

`curl "192.168.1.23:5000/api/ai?pin=2"`

Writing `2035` to Analog Output 4

`curl "192.168.1.23:5000/api/ao?pin=4&val=2035"`

Getting the temperature

`curl "192.168.1.23:5000/api/temperature"`
