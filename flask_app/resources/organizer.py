from flask_restful import Resource, reqparse
from flask_jwt import jwt_required
from models.organizer import OrganizerModel

class Organizer(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument("description", required=True, help="Organizer needs a description.")
    parser.add_argument("email", required=True, help="Organizer needs an email.")
    parser.add_argument("address", required=True, help="Organizer needs an address.")
    parser.add_argument("is_official", type=int, required=True, help="Organizer needs to specify if it is official.")

    def get(self, name):
        organizer = OrganizerModel.find_organizer_by_name(name)
        if organizer:
            return {"organizer_result": organizer.json()}
        return {"message": "Organizer not found"}, 404

    @jwt_required()
    def post(self, name):
        data = Organizer.parser.parse_args()
        if OrganizerModel.find_organizer_by_name(name):
            return {"message": "An organizer with name '{}' already exists. Please try to use another name".format(name)}, 400

        organizer = OrganizerModel(name, **data)
        try:
            organizer.save_to_db()
        except:
            return {"message": "An error ocurred inserting the organizer."}, 500
        return {"organizer_result": organizer.json()}, 201

    @jwt_required()
    def delete(self, name):
        organizer = OrganizerModel.find_organizer_by_name(name)
        if organizer:
            organizer.delete_from_db()
            return {"message": "Organizer deleted"}
        return {"message": "Organizer not found"}

class OrganizerList(Resource):
    def get(self):
        return {"organizer_results": list(map(lambda x: x.json(), OrganizerModel.query.all()))}
