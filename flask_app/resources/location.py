from extensions import jwt
from flask_jwt_extended import JWTManager, jwt_required, create_access_token, get_jwt_identity
from flask_restplus import Namespace, Resource
from models.location import LocationModel

api = Namespace('Location', description='Operations related to availble rooms and spaces')



@api.route('location/<string:name>')
@api.param('name', 'Room or space name (NQ 2435, NQ Student Lounge)')
class Location(Resource):

    parser = api.parser()
    parser.add_argument("capacity", default=0, help="Capacity for students, 0 as unknown")


    @api.doc(security=None, responses={200:'OK', 404: 'Not found'})
    def get(self, name):
        """displays a location's details"""
        location = LocationModel.find_location_by_name(name)
        if location:
            return {"location_result": location.json()}, 200
        return {"message": "Location not found"}, 404


    @api.doc(security='JWT', responses={201:'Created', 400: 'Bad request: item already exsits', 500: 'Database internal error', 401:'No authorization'})
    @jwt_required
    @api.expect(parser)
    def post(self, name):
        """adds a new location"""
        data = Location.parser.parse_args()
        if LocationModel.find_location_by_name(name):
            return {"message": "A location with name '{}' already exists. Please try to use another name".format(name)}, 400

        location = LocationModel(name, **data)
        try:
            location.save_to_db()
        except:
            return {"message": "An error ocurred inserting the location."}, 500
        return {"location_result": location.json()}, 201


    @api.doc(security='JWT', responses={204:'No content returned', 404: 'Not found', 401:'No authorization'})
    @jwt_required
    def delete(self, name):
        """deletes a location by name"""
        location = LocationModel.find_location_by_name(name)
        if location:
            location.delete_from_db()
            return {"message": "Location deleted"}
        return {"message": "Location not found"}



@api.route('locations')
class LocationList(Resource):
    @api.doc(security=None, responses={200:'OK'})
    def get(self):
        """returns a list of locations"""
        return {"location_results": list(map(lambda x: x.json(), LocationModel.query.all()))}, 200
