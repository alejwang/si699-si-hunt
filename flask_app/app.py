from flask import Flask, redirect, request
from extensions import jwt, db
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager, jwt_required, create_access_token, get_jwt_identity
from flask_restplus import Resource, Api
from resources import api
import datetime

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_EXPIRATION_DELTA'] = datetime.timedelta(minutes=20)
app.config['JWT_SECRET_KEY'] = 'team_fancyfancy'
app.config['PROPAGATE_EXCEPTIONS'] = True
app.config['SWAGGER_UI_DOC_EXPANSION'] = 'list'
app.secret_key = 'team_fancyfancy'

db.init_app(app)
jwt.init_app(app)
api.init_app(app)
jwt._set_error_handler_callbacks(api)

@app.before_first_request
def create_tables():
    db.create_all()

if __name__ == '__main__':
    # app = create_app()
    app.run(port=5000, debug=True)
