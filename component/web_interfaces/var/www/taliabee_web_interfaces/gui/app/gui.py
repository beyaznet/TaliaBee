from flask import Blueprint, jsonify, request, abort
from app.storage.data import update_data_name, load_data
from config import API_URL
import requests

gui = Blueprint('gui', __name__, url_prefix='/gui')

OUTPUTS = {}

@gui.route('/status', methods=['GET'])
def status():
    try:
        req = requests.get(API_URL + '/api/status')
        res = req.json()
    except:
        return jsonify({'status': 'error'})

    temperature_value = res['value']['temperature']

    status_data = {'do': [], 'di': [], 'ao': [], 'ai': [], 'ro': []}
    status_type = ['do', 'di', 'ai', 'ao', 'ro']
    for i in status_type:
        for j in res['value'][i]:
            status_data[i].append({'id': int(j), 'type': i, 'name': '',
                                   'value': res['value'][i][j]})

    return jsonify({'status': 'OK',
                    'value': status_data,
                    'temperature': temperature_value})


@gui.route('/data', methods=['GET'])
def data():
    DATA = load_data()
    return jsonify({'status': 'OK',
                    'data_list': {'analog_output': DATA['analog']['output'],
                                  'analog_input': DATA['analog']['input'],
                                  'digital_outputs': DATA['digital']['output'],
                                  'digital_inputs': DATA['digital']['input'],
                                  'relay_outputs': DATA['relay']['output']}})

@gui.route('/update', methods=['POST'])
def update_name():
    type_dict = {'ai': 'analog', 'ao': 'analog', 'do': 'digital',
                 'di': 'digital', 'ro': 'relay'}

    for data_type, value in type_dict.items():
        for data in request.json[data_type]:
            try:
                update_data_name(value, data_type, data['id'], data['name'])
            except:
                abort(400)

    return jsonify({'status': 'OK'})
