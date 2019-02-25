# See the following document or tutorials:
# https://hackernoon.com/learning-flask-being-an-ios-developer-3c6ec8c2ba83

from flask import Flask
from flask_restful import Api
from flask_jwt import JWT

from db import db

from security import authenticate, identity
from resources.user import UserRegister
from resources.event import Event, EventList
from resources.organizer import Organizer, OrganizerList
from resources.location import Location, LocationList

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = "mysql://alejwang:****PASSWORD****@alejwang.mysql.pythonanywhere-services.com/alejwang$si699" # REMEMBER TO CHANGE THE PASSWORD!
app.config["SQLALCHEMY_POOL_RECYCLE"] = 299
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.secret_key = 'team_****PASSWORD****' # REMEMBER TO CHANGE THE PASSWORD!

# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db' # this line is for local debugging only

db.init_app(app)

@app.before_first_request
def create_tables():
    db.create_all()

api = Api(app)
api.add_resource(Event, '/event/<string:name>')
api.add_resource(EventList, '/events')
api.add_resource(Organizer, '/organizer/<string:name>')
api.add_resource(OrganizerList, '/organizers')
api.add_resource(Location, '/location/<string:name>')
api.add_resource(LocationList, '/locations')
api.add_resource(UserRegister, '/register')

jwt = JWT(app, authenticate, identity)

if __name__ == '__main__':
    app.run(port=5000, debug=True) # this line is for local debugging only
