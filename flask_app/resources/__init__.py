from flask_restplus import Api
from .user import api as ns0
from .organizer import api as ns2
from .location import api as ns3
from .event import api as ns1
from .navigation import api as ns4
from .tag import api as ns5



authorizations = {
    "JWT": {
      "description": "",
      "type": "apiKey",
      "name": "Authorization",
      "in": "header"
    }
}

api = Api(
    title='SIHunt Admin',
    version='1.1',
    description='Flask RestPlus powered API for 699. Now with tags.',
    authorizations=authorizations,
    security='JWT'
    # All API metadatas
)

api.add_namespace(ns0,path='/')
api.add_namespace(ns1,path='/')
api.add_namespace(ns2,path='/')
api.add_namespace(ns3,path='/')
api.add_namespace(ns4,path='/')
api.add_namespace(ns5,path='/')