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

The interface contains 14 endpoints

- `/api/ai/<int:pin>/read`: This endpoint reads Analog Inputs' values.

- `/api/ao/<int:pin>/write`: This endpoint writes to Analog Outputs.
- `/api/ao/<int:pin>/read`: This endpoint reads Analog Outputs' values.

- `/api/di/<int:pin>/read`: This endpoint reads Digital Inputs' values.

- `/api/do/<int:pin>/write`: This endpoint writes to Digital Outputs.
- `/api/do/<int:pin>/read`: This endpoint reads Digital Outputs' values.
- `/api/do/<int:pin>/set`: This endpoint writes `1` to a Digital Output.
- `/api/do/<int:pin>/reset`: This endpoint writes `0` to a Digital Output.

- `/api/ro/<int:pin>/read`: This endpoint reads Relay Outputs' values.
- `/api/ro/<int:pin>/write`: This endpoint writes to a Relay Output.
- `/api/ro/<int:pin>/set`: This endpoint writes `1` to a Relay Output.
- `/api/ro/<int:pin>/reset`: This endpoint writes `0` to a Relay Output.

- `/api/status`: This endpoint reads everything.
- `/api/reset`: This endpoint writes '0' to all Outputs.

- `/api/temperature/read`: This endpoint reads from the default temperature sensor on MedIOEx. Gives floating value. (Celsius)

These endpoints accepts the parameters below:

- `pin`: `[1-4]` for Analog Outputs and Analog Inputs, `[1-12]` for Digital Outputs, `[13-16]` for Relay  Outputs, `[1-16]` for Digital Inputs.

- `val`: `[0-1]` for Digitals, `[0-4095]` for Analogs.

**Note**: `val` parameter is only for writing purposes. All endpoints return JSON.

### Quick Examples

Assume that your RaspberryPi's IP address is `192.168.1.23` and you're running the web interface with the port `5000`


- Read Analog Input 1 (`AI1`)

  `curl "localhost:5000/api/ai/1/read"`

- Write `2049` to Analog Output 1 (`AO1`)

  `curl "localhost:5000/api/ao/1/write?val=2049"`

- Read Analog Output 1 (`AO1`)

  `curl "localhost:5000/api/ao/1/read"`

- Read Digital Input 6 (`DI6`)
  
  `curl "localhost:5000/api/di/6/read"`

- Write `1` to Digital Output 2 (`DO2`)

  `curl "localhost:5000/api/do/2/write?val=1"`

  `curl "localhost:5000/api/do/2/set"`

- Read Digital Output 2 (`DO2`)

  `curl "localhost:5000/api/do/2/read"`

- Write `1` to Digital Output 2 (`DO2`)

  `curl "localhost:5000/api/do/2/write?val=0"`

  `curl "localhost:5000/api/do/2/reset"`

- Read Relay Output 13 (`R13`)

  `curl "localhost:5000/api/ro/13/read"`

- Write `1` to Relay Output 13 (`R13`)

  `curl "localhost:5000/api/ro/13/write?val=1"`

  `curl "localhost:5000/api/ro/13/set"`

- Write `0` to Relay Output 13 (`R13`)

  `curl "localhost:5000/api/ro/13/write?val=0"`

  `curl "localhost:5000/api/ro/13/reset"`

- Read temperature

  `curl "localhost:5000/api/temperature/read"`

- Get all inputs and outputs

  `curl "localhost:5000/api/status"`

- Write `0` to all possible outputs (digital and analog)

  `curl "localhost:5000/api/reset"`
