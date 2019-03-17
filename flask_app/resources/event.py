from flask_restful import Resource, reqparse
from flask_jwt import jwt_required
from datetime import datetime

from models.event import EventModel
from models.organizer import OrganizerModel
from models.location import LocationModel

class Event(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument("description", required=True, help="Event needs a description.")
    parser.add_argument("capacity", type=int, required=True, help="Event needs a capacity.")
    parser.add_argument("organizer_id", type=int, required=True, help="Event needs an organizer id.")
    parser.add_argument("start_time", type=lambda s: datetime.strptime(s, "%Y-%m-%d %H:%M"), required=True, help="Event needs a start time.")
    parser.add_argument("end_time", type=lambda s: datetime.strptime(s, "%Y-%m-%d %H:%M"), required=True, help="Event needs a end time.")
    parser.add_argument("location_id", type=int, required=True, help="Event needs a location id.")
    parser.add_argument("is_published", type=int, required=True, help="Event needs a is_publish tag.")
    parser.add_argument("pub_date", type=lambda s: datetime.strptime(s, "%Y-%m-%d %H:%M"), required=True, help="Event needs a publish date.")

    def get(self, name):
        event = EventModel.find_event_by_name(name)
        if event:
            return {"event_result": event.json()}
        return {"message": "Event not found"}, 404

    @jwt_required()
    def post(self, name):
        data = Event.parser.parse_args()
        if EventModel.find_event_by_name(name):
            return {"message": "An event with name '{}' already exists. Please try to use another name".format(name)}, 400
        if not LocationModel.find_location_by_id(data["location_id"]):
            return {"message": "Location_id not valid".format(data["location_id"])}, 400
        if not OrganizerModel.find_organizer_by_id(data["organizer_id"]):
            return {"message": "Holder_id not valid".format(data["holder_id"])}, 400

        # print(data)
        event = EventModel(name, **data)
        # print(event.json()) can't do it here because no commitment made to create the foreign key
        try:
            event.save_to_db()
        except Exception as e:
            return {"message": "An error ocurred inserting the event: {}".format(e)}, 500
        return {"event_result": event.json()}, 201

    @jwt_required()
    def delete(self, id):
        event = EventModel.find_event_by_id(id)
        if event:
            event.delete_from_db()
            return {"message": "Event deleted"}
        return {"message": "Event not found"}

class EventList(Resource):
    def get(self, period="all"):
        return {"event_results": list(map(lambda x: x.json(), EventModel.query.all()))}
        # To-do?: period is ongoing_and_coming / history / all?
