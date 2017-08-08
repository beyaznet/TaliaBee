from flask import Blueprint, jsonify
# from flask import request
from app.storage.data import data as DATA
import requests


gui = Blueprint('gui', __name__, url_prefix='/gui')

OUTPUTS = {}

@gui.route('/status', methods=['GET'])
def status():
    # url = request.referrer
    # requestpost = requests.get(url + 'api/status')
    requestpost = requests.get('http://172.22.9.13/api/status')
    response_data = requestpost.json()
    temperature_value = response_data['value']['temperature']

    status_data = {'do': [], 'di': [], 'ao': [], 'ai': [], 'ro': []}
    status_type = ['do', 'di', 'ai', 'ao', 'ro']

    for i in status_type:
        for j in response_data['value'][i]:
            status_data[i].append({'id': j, 'type': i, 'name': i + j,
                                   'value': response_data['value'][i][j]})
    return jsonify({'status': 'OK',
                    'value': status_data,
                    'temperature': temperature_value})


@gui.route('/data', methods=['GET'])
def analog():
    analog_outputs = DATA['analog']['output']
    analog_inputs = DATA['analog']['input']
    digital_outputs = DATA['digital']['output']
    digital_inputs = DATA['digital']['input']
    relay_outputs = DATA['relay']['output']

    return jsonify({'status': 'OK',
                    'data_list': {'analog_output': analog_outputs,
                                  'analog_input': analog_inputs,
                                  'digital_outputs': digital_outputs,
                                  'digital_inputs': digital_inputs,
                                  'relay_outputs': relay_outputs}})
