from flask_restful import Resource, reqparse
from flask_jwt import jwt_required
from models.location import LocationModel

class Location(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument("capacity", help="Location needs a capacity.")

    def get(self, name):
        location = LocationModel.find_location_by_name(name)
        if location:
            return {"location_result": location.json()}
        return {"message": "Location not found"}, 404

    @jwt_required()
    def post(self, name):
        data = Location.parser.parse_args()
        if LocationModel.find_location_by_name(name):
            return {"message": "A location with name '{}' already exists. Please try to use another name".format(name)}, 400

        location = LocationModel(name, **data)
        try:
            location.save_to_db()
        except:
            return {"message": "An error ocurred inserting the location."}, 500
        return {"location_result": location.json()}, 201

    @jwt_required()
    def delete(self, name):
        location = LocationModel.find_location_by_name(name)
        if location:
            location.delete_from_db()
            return {"message": "Location deleted"}
        return {"message": "Location not found"}

class LocationList(Resource):
    def get(self):
        return {"location_results": list(map(lambda x: x.json(), LocationModel.query.all()))}
