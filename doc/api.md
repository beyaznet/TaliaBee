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
- [Analog input read](#analog-input-read)
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
curl "http://127.0.0.1/api/do/8/read"
{
  "action": "read", 
  "pin": 8, 
  "status": "OK", 
  "type": "do", 
  "value": 0
}
```

Digital output set
==================
```bash
/api/do/<int:pin>/set
```

Set the digital output. `pin` is the digital output pin number and it's an integer between 1 and 12.

```bash
curl "http://127.0.0.1/api/do/8/set" 
{
  "action": "set", 
  "pin": 8, 
  "status": "OK", 
  "type": "do", 
  "value": 1
}
```

Digital output reset
====================
```bash
/api/do/<int:pin>/reset
```

Reset the digital output. `pin` is the digital output pin number and it's an integer between 1 and 12.

```bash
curl "http://127.0.0.1/api/do/8/reset"
{
  "action": "reset", 
  "pin": 8, 
  "status": "OK", 
  "type": "do", 
  "value": 0
}
```

Digital output write
====================
```bash
/api/do/<int:pin>/write?val=<int:val>
```

Write to the digital output. `pin` is the digital output pin number and it's an integer between 1 and 12. `val` is either `0` or `1`.

```bash
curl "http://127.0.0.1/api/do/3/write?val=1"
{
  "action": "write", 
  "pin": 3, 
  "status": "OK", 
  "type": "do", 
  "value": 1
}
```

Relay output read
=================
```bash
/api/ro/<int:pin>/read
```

Return the value of the relay output. `pin` is the relay output pin number and it's an integer between 13 and 16. The returning value is either `0` or `1`.

```bash
curl "http://127.0.0.1/api/ro/14/read"     
{
  "action": "read", 
  "pin": 14, 
  "status": "OK", 
  "type": "ro", 
  "value": 0
}
```

Relay output set
================
```bash
/api/ro/<int:pin>/set
```

Set the relay output. `pin` is the relay output pin number and it's an integer between 13 and 16.

```bash
curl "http://127.0.0.1/api/ro/14/set" 
{
  "action": "set", 
  "pin": 14, 
  "status": "OK", 
  "type": "ro", 
  "value": 1
}
```

Relay output reset
==================
```bash
/api/ro/<int:pin>/reset
```

Reset the relay output. `pin` is the relay output pin number and it's an integer between 13 and 16.

```bash
curl "http://127.0.0.1/api/ro/14/reset"
{
  "action": "reset", 
  "pin": 14, 
  "status": "OK", 
  "type": "ro",
  "value": 0
}
```

Relay output write
==================
```bash
/api/ro/<int:pin>/write?val=<int:val>
```

Write to the relay output. `pin` is the relay output pin number and it's an integer between 13 and 16. `value` is either `0` or `1`.

```bash
curl "http://127.0.0.1/api/ro/14/write?val=1"
{
  "action": "write", 
  "pin": 14, 
  "status": "OK", 
  "type": "ro", 
  "value": 1
}
```

Analog input read
=================
```bash
/api/ai/<int:pin>/read
```

Return the value of the analog input. `pin` is the analog input pin number and it's an integer between 1 and 4. The returning value is an integer between 1 and 4095.

```bash
curl "http://127.0.0.1/api/ai/2/read"       
{
  "action": "read", 
  "pin": 2, 
  "status": "OK", 
  "type": "ai", 
  "value": 8
}
```

Analog output read
==================
```bash
/api/ao/<int:pin>/read
```

Return the value of the analog output. `pin` is the analog output pin number and it's an integer between 1 and 4. The returning value is an integer between 1 and 4095.

```bash
curl "http://127.0.0.1/api/ao/2/read"
{
  "action": "read", 
  "pin": 2, 
  "status": "OK", 
  "type": "ao", 
  "value": 0
}
```

Analog output write
===================
```bash
/api/ao/<int:pin>/write?val=<int:val>
```

Write to the analog output. `pin` is the analog output pin number and it's an integer between 1 and 4. `value` is an integer between 1 and 4095.

```bash
curl "http://127.0.0.1/api/ao/2/write?val=500"
{
  "action": "write", 
  "pin": 2, 
  "status": "OK", 
  "type": "ao", 
  "value": 500
}
```

Temperature read
================
```bash
/api/temperature/read
```

Return the temperature value in Celsius.

```bash
curl "http://127.0.0.1/api/temperature/read"  
{
  "action": "read", 
  "status": "OK", 
  "type": "temperature", 
  "value": 34.5
}
```

Status
======
```bash
/api/status
```

Return the values of all digital and analog I/O and the temperature.

```bash
curl "http://127.0.0.1/api/status"
{
  "action": "status", 
  "status": "OK", 
  "value": {
    "ai": {
      "1": 0, 
      "2": 0, 
      "3": 0, 
      "4": 0
    }, 
    "ao": {
      "1": 0, 
      "2": 500, 
      "3": 0, 
      "4": 0
    }, 
    "di": {
      "1": 0, 
      "2": 0, 
      "3": 0, 
      "4": 0, 
      "5": 0, 
      "6": 0, 
      "7": 0, 
      "8": 0, 
      "9": 0, 
      "10": 0, 
      "11": 0, 
      "12": 0, 
      "13": 0, 
      "14": 0, 
      "15": 0, 
      "16": 0
    }, 
    "do": {
      "1": 0, 
      "2": 0, 
      "3": 1, 
      "4": 0, 
      "5": 0, 
      "6": 0, 
      "7": 1, 
      "8": 0, 
      "9": 0, 
      "10": 0, 
      "11": 0, 
      "12": 0
    }, 
    "ro": {
      "13": 0, 
      "14": 1, 
      "15": 0, 
      "16": 0
    }, 
    "temperature": 35.75
  }
}
```

Reset
=====
```bash
/api/reset
```

Reset all digital and analog outputs.

```bash
curl "http://127.0.0.1/api/reset" 
{
  "action": "reset", 
  "status": "OK", 
  "value": null
}
```
