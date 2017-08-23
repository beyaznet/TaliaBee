from flask import Flask
from app.api import api, OUTPUTS
from datetime import datetime
from medioex import do_di_init, ai_init, ao_init, temp_init


do_di_init()
ai_init()
ao_init()
temp_init()


# OUTPUTS referenced in app.api
OUTPUTS['start_timestamp'] = datetime.now().timestamp()
OUTPUTS['do'] = {i: 0 for i in range(1, 13)}
OUTPUTS['ro'] = {i: 0 for i in range(13, 17)}
OUTPUTS['ao'] = {i: 0 for i in range(1, 5)}


app = Flask(__name__)
app.register_blueprint(api)
