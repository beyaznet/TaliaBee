import json
# from pprint import pprint
from config import DATA_PATH
# DATA_PATH = 'data.json'


def load_data():
    with open(DATA_PATH) as f:
        return json.load(f)


def update_data_name(component, data_type, pin, name):
    data = load_data()
    if data_type == 'ai' or data_type == 'di':
        type = 'input'
    else:
        type = 'output'

    if component == 'relay':
        data[component][type][int(pin) - 13]['name'] = name
    else:
        data[component][type][int(pin) - 1]['name'] = name

    with open(DATA_PATH, 'w') as f:
        json.dump(data, f, indent=2, sort_keys=True)

