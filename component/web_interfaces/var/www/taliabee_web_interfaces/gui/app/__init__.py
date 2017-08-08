from flask import Flask, render_template
from app.gui import gui, OUTPUTS


# OUTPUTS referenced in app.gui
OUTPUTS['do'] = {i: 0 for i in range(1, 13)}
OUTPUTS['ro'] = {i: 0 for i in range(13, 17)}
OUTPUTS['ao'] = {i: 0 for i in range(1, 5)}

app = Flask(__name__)
app.register_blueprint(gui)


@app.route('/')
# @requires_auth
def index():
    return render_template('index.html')


@app.route('/a')
def a():
    return render_template('asd.html')
