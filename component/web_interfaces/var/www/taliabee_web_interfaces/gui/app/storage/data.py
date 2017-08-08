import json
# from pprint import pprint
from config import DATA_PATH
# DATA_PATH = 'data.json'


def load_data():
    with open(DATA_PATH) as f:
        return json.load(f)


def set_digital_data(type, pin, pin_value):
    data = load_data()

    data['digital'][type][int(pin) - 1]['value'] = pin_value

    with open(DATA_PATH, 'w') as f:
        json.dump(data, f, indent=2, sort_keys=True)


def update_digital_name(type, pin, name):
    data = load_data()
    data['digital'][type][int(pin) - 1]['name'] = name

    with open(DATA_PATH, 'w') as f:
        json.dump(data, f, indent=2, sort_keys=True)


data = load_data()
# set_digital_output_name()
