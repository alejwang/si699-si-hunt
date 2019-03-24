from extensions import jwt
from flask_restplus import Namespace, Resource
from models.tag import TagModel

api = Namespace('Tag', description='tags')

@api.route("tag/<name>")
@api.param("name", "tag unique name")
class Tag(Resource):

    parser = api.parser()
    parser.add_argument("priority", type=int, default='1', required=False)


    @api.doc(security=None, responses={200:'OK', 401: 'No authorization'})
    @api.expect(parser)
    def post(self, name):
        data = Tag.parser.parse_args()
    
        if TagModel.find_tag_by_name(name):
            return {"message": "A tag with name '{}' already exists. Please try to use another name".format(name)}, 400

        tag = TagModel(name=name, priority=data['priority'])
        try:
            tag.save_to_db()
        except:
            return {"message": "An error ocurred inserting the organizer."}, 500
        return {"tag_result": tag.json()}, 201
        



@api.route('tags')
class TagList(Resource):
    @api.doc(security=None, responses={200:'OK'})
    def get(self):
        """returns a list of organizers"""
        return {"tag_results": list(map(lambda x: x.json(), TagModel.query.all()))}, 200
