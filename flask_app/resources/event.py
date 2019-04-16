from extensions import jwt
from flask_jwt_extended import JWTManager, jwt_required
from flask_restplus import Namespace, Resource
from datetime import datetime
from models.event import EventModel
from models.organizer import OrganizerModel
from models.location import LocationModel

api = Namespace('Event', description='Events waiting for students to discover')



@api.route('event/<string:name>')
@api.param('name', 'Event name')
class Event(Resource):

    parser = api.parser()
    parser.add_argument("description", required=True, default="cool!", help="Event needs a description.")
    parser.add_argument("capacity", type=int, required=True, default=10,help="Event needs a capacity.")
    parser.add_argument("organizer_id", type=int, required=True, help="Event needs an organizer id.")
    parser.add_argument("start_time", type=lambda s: datetime.strptime(s, "%Y-%m-%d %H:%M"), required=True, default="2019-04-30 10:00",help="Event needs a start time.")
    parser.add_argument("end_time", type=lambda s: datetime.strptime(s, "%Y-%m-%d %H:%M"), required=True, default="2019-04-30 12:00", help="Event needs a end time.")
    parser.add_argument("location_id", type=int, required=True, help="Event needs a location id.")
    parser.add_argument("is_published", type=int, required=True, default=False, help="Event needs a is_publish tag.")
    parser.add_argument("pub_date", type=lambda s: datetime.strptime(s, "%Y-%m-%d %H:%M"), required=True, default="2019-03-01 12:00",help="Event needs a publish date.")
    parser.add_argument('tags_list', action='append')


    @api.doc(security=None, responses={200:'OK', 404: 'Not found'})
    def get(self, name):
        """displays an event's details"""
        event = EventModel.find_event_by_name(name)
        if event:
            return {"event_result": event.json()}, 200
        return {"message": "Event not found"}, 404


    @api.doc(security='JWT', responses={201:'Created', 400: 'Bad request', 500: 'Database internal error', 401:'No authorization'})
    @jwt_required
    @api.expect(parser)
    def post(self, name):
        """adds a new event"""
        data = Event.parser.parse_args()
        if EventModel.find_event_by_name(name):
            return {"message": "An event with name '{}' already exists. Please try to use another name".format(name)}, 400
        if not LocationModel.find_location_by_id(data["location_id"]):
            return {"message": "Location_id not valid"}, 400
        if not OrganizerModel.find_organizer_by_id(data["organizer_id"]):
            return {"message": "Holder_id not valid"}, 400

        event = EventModel(name, **data)
        try:
            event.save_to_db()
        except Exception as e:
            return {"message": "An error ocurred inserting the event: {}".format(e)}, 500
        return {"event_result": event.json()}, 201


    @api.doc(security='JWT', responses={204:'OK - No content returned', 404: 'Not found', 401:'No authorization'})
    @jwt_required
    def delete(self, id):
        """deletes an event by name"""
        event = EventModel.find_event_by_id(id)
        if event:
            event.delete_from_db()
            return {"message": "Event deleted"}
        return {"message": "Event not found"}



@api.route('events')
class EventList(Resource):
    @api.doc(security=None, responses={200:'OK'})
    def get(self, period="all"):
        """returns a list of events"""
        return {"event_results": list(map(lambda x: x.json(), EventModel.query.order_by(EventModel.start_time).all()))}
        # To-do?: period is ongoing_and_coming / history / all?
