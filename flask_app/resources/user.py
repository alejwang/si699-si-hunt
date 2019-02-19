from flask_restful import Resource, reqparse
from models.user import UserModel

class UserRegister(Resource):

    parser = reqparse.RequestParser()
    parser.add_argument('username', type=str, required=True, help="User needs to have a username.")
    parser.add_argument('password', type=str, required=True, help="User needs to have a password.")

    def post(self):
        data = UserRegister.parser.parse_args()

        if UserModel.find_user_by_username(data['username']):
            return {"message": "User already exists"}, 400

        user = UserModel(**data)
        user.save_to_db()

        return {"message": "User created successfully."}, 201
