from flask_restful import Resource
from models.school import SchoolModel

class School(Resource):
    def get(self, name):
        school = SchoolModel.find_by_name(name)
        if school:
            return school.json()
        return {'message': 'School not found'}, 404

    def post(self, name):
        if SchoolModel.find_by_name(name):
            return {'message': "School '{}' already exists".format(name)}, 400

        school = SchoolModel(name)
        try:
            school.save_to_db()
        except:
            return {'message': 'An error occurred while creating the school'}, 500

        return school.json(), 201

    def delete(self, name):
        school = SchoolModel.find_by_name(name)
        if school:
            school.delete_from_db()

        return {'message': 'School deleted'}

class SchoolList(Resource):
    def get(self):
        return {'schools': list(map(lambda x: x.json(), SchoolModel.query.all()))}
