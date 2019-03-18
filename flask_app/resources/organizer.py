from extensions import jwt
from flask_jwt_extended import JWTManager, jwt_required
from flask_restplus import Namespace, Resource
from models.organizer import OrganizerModel

api = Namespace('Organizer', description='School offices and student clubs')



@api.route('organizer/<string:name>')
@api.param('name', 'Office or club fullname')
class Organizer(Resource):

    parser = api.parser()
    parser.add_argument("description", type=str, required=True)
    parser.add_argument("email", type=str, required=True)
    parser.add_argument("address", type=str, required=True)
    parser.add_argument("is_official", type=int, required=True, help="1 - Offical office, 0 - Not")
    

    @api.doc(security=None, responses={200:'OK', 404: 'Not found'})
    def get(self, name):
        """displays an organizer's details"""
        organizer = OrganizerModel.find_organizer_by_name(name)
        if organizer:
            return {"organizer_result": organizer.json()}, 200
        return {"message": "Organizer not found"}, 404


    @api.doc(security='JWT', responses={201:'Created', 400: 'Bad request: item already exsits', 500: 'Database internal error', 401:'No authorization'})
    @jwt_required
    @api.expect(parser)
    def post(self, name):
        """adds a new organizer"""
        data = Organizer.parser.parse_args()
        if OrganizerModel.find_organizer_by_name(name):
            return {"message": "An organizer with name '{}' already exists. Please try to use another name".format(name)}, 400

        organizer = OrganizerModel(name, **data)
        try:
            organizer.save_to_db()
        except:
            return {"message": "An error ocurred inserting the organizer."}, 500
        return {"organizer_result": organizer.json()}, 201


    @api.doc(security='JWT', responses={204:'OK - No content returned', 404: 'Not found', 401:'No authorization'})
    @jwt_required
    def delete(self, name):
        """deletes an organizer by name"""
        organizer = OrganizerModel.find_organizer_by_name(name)
        if organizer:
            organizer.delete_from_db()
            return {"message": "Organizer deleted"}, 204
        return {"message": "Organizer not found"}, 404



@api.route('organizers')
class OrganizerList(Resource):
    @api.doc(security=None, responses={200:'OK'})
    def get(self):
        """returns a list of organizers"""
        return {"organizer_results": list(map(lambda x: x.json(), OrganizerModel.query.all()))}, 200
