from flask import Flask
from database.db import initialize_db
from flask_restful import Api

app = Flask(__name__)

from resources.routes import initialize_routes

api = Api(app)

app.config['MONGODB_SETTINGS'] = {
    'host': 'mongodb://127.0.0.1:27017/foodForThought'
}

initialize_db(app)
initialize_routes(api)