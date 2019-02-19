# See the following document or tutorials:
# https://hackernoon.com/learning-flask-being-an-ios-developer-3c6ec8c2ba83

from flask import Flask
from flask_restful import Api
from flask_jwt import JWT

from security import authenticate, identity
from resources.user import UserRegister
from resources.event import Event, EventList
from resources.organizer import Organizer, OrganizerList
from resources.location import Location, LocationList

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.secret_key = 'team_fancyfancy'
api = Api(app)

@app.before_first_request
def create_tables():
    db.create_all()

jwt = JWT(app, authenticate, identity)


api.add_resource(Event, '/event/<string:name>')
api.add_resource(EventList, '/events')
api.add_resource(Organizer, '/organizer/<string:name>')
api.add_resource(OrganizerList, '/organizers')
api.add_resource(Location, '/location/<string:name>')
api.add_resource(LocationList, '/locations')

api.add_resource(UserRegister, '/register')

if __name__ == '__main__':
    from db import db
    db.init_app(app)
    app.run(port=5000, debug=True)
