TaliaBee API
============
TaliaBee API can be used to monitor and to control the I/O pins of the TaliaBee box. All endpoints implemented as a `GET` request. So you can use `curl` to test it quickly.

Table of contents
=================
- [Digital input read](#digital-input-read)
- [Digital output read](#digital-output-read)
- [Digital output set](#digital-output-set)
- [Digital output reset](#digital-output-reset)
- [Digital output write](#digital-output-write)
- [Relay output read](#relay-output-read)
- [Relay output set](#relay-output-set)
- [Relay output reset](#relay-output-reset)
- [Relay output write](#relay-output-write)
- [Analog imput read](#analog-imput-read)
- [Analog output read](#analog-output-read)
- [Analog output write](#analog-output-write)
- [Temperature read](#temperature-read)
- [Status](#status)
- [Reset](#reset)


Digital input read
==================
```bash
/api/di/<int:pin>/read
```

Return the value of the digital input. `pin` is the digital input pin number and it's an integer between 1 and 16. The returning value is either `0` or `1`.

```bash
curl "http://127.0.0.1/api/di/2/read"
{
  "action": "read", 
  "pin": 2, 
  "status": "OK", 
  "type": "di", 
  "value": 0
}
```

Digital output read
===================
```bash
/api/do/<int:pin>/read
```

Return the value of the digital output. `pin` is the digital output pin number and it's an integer between 1 and 12. The returning value is either `0` or `1`.

```bash
```

Digital output set
==================
```bash
/api/do/<int:pin>/set
```

Set the digital output. `pin` is the digital output pin number and it's an integer between 1 and 12.

```bash
```

Digital output reset
====================
```bash
/api/do/<int:pin>/reset
```

Reset the digital output. `pin` is the digital output pin number and it's an integer between 1 and 12.

```bash
```

Digital output write
====================
```bash
/api/do/<int:pin>/write?val=<int:val>
```

Write to the digital output. `pin` is the digital output pin number and it's an integer between 1 and 12. `val` is either `0` or `1`.

```bash
```

Relay output read
=================
```bash
/api/ro/<int:pin>/read
```

Return the value of the relay output. `pin` is the relay output pin number and it's an integer between 13 and 16. The returning value is either `0` or `1`.

```bash
```

Relay output set
================
```bash
/api/ro/<int:pin>/set
```

Set the relay output. `pin` is the relay output pin number and it's an integer between 13 and 16.

```bash
```

Relay output reset
==================
```bash
/api/ro/<int:pin>/reset
```

Reset the relay output. `pin` is the relay output pin number and it's an integer between 13 and 16.

```bash
```

Relay output write
==================
```bash
/api/ro/<int:pin>/write?val=<int:val>
```

Write to the relay output. `pin` is the relay output pin number and it's an integer between 13 and 16. `value` is either `0` or `1`.

```bash
```

Analog imput read
=================
```bash
/api/ai/<int:pin>/read
```

Return the value of the analog input. `pin` is the analog input pin number and it's an integer between 1 and 4. The returning value is an integer between 1 and 4095.

```bash
```

Analog output read
==================
```bash
/api/ao/<int:pin>/read
```

Return the value of the analog output. `pin` is the analog output pin number and it's an integer between 1 and 4. The returning value is an integer between 1 and 4095.

```bash
```

Analog output write
===================
```bash
/api/ao/<int:pin>/write?val=<int:val>
```

Write to the analog output. `pin` is the analog output pin number and it's an integer between 1 and 4. `value` is an integer between 1 and 4095.

```bash
```

Temperature read
================
```bash
/api/temperature/read
```

Return the temperature value in Celsius.

```bash
```

Status
======
```bash
/api/status
```

Return the values of all digital and analog I/O and the temperature.

```bash
```

Reset
=====
```bash
/api/reset
```

Reset all digital and analog outputs.

```bash
```
