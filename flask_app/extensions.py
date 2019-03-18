from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager

db = SQLAlchemy()
jwt = JWTManager()

# https://github.com/vimalloc/flask-jwt-extended/tree/master/examples/database_blacklist