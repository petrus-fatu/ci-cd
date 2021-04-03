import os
import logging

from flask import Flask, render_template
from whitenoise import WhiteNoise


app = Flask(__name__)
app.secret_key = '[keep it secret]'
static_dir = os.path.join(os.path.dirname(__file__), 'static')
app.wsgi_app = WhiteNoise(app.wsgi_app, root=static_dir, prefix='static/')

@app.route('/')
def index():
    return render_template('index.html')

@app.errorhandler(500)
def server_error(e):
    logging.exception('An error occurred during a request.')
    return """
    An internal error occurred: <pre>{}</pre>
    See logs for full stacktrace.
    """.format(e), 500

if __name__ == '__main__':
    app.jinja_env.auto_reload = True
    app.config['TEMPLATES_AUTO_RELOAD'] = True
    app.run(debug=True)