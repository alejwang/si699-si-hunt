from flask_restful import Resource, reqparse
from flask_jwt import jwt_required

from models.navigation import NavNodeModel, NavLinkModel
from models.location import LocationModel

import math

allowed_special_type = ['elevator', 'stair']

class NavNode(Resource):

    parser = reqparse.RequestParser()
    parser.add_argument("default_exit_direction", type=int, required=True, help="Point needs a default exit direction.")
    parser.add_argument("special_type", type=lambda s: s if s in allowed_special_type else None)
    parser.add_argument("location_name", type=lambda s: s if s else None)

    def get(self, building, level, pos_x, pos_y):
        try:
            filters = {
                'building': building,
                'level': int(level),
                'pos_x': int(pos_x),
                'pos_y': int(pos_y)
            }
        except:
            return {"message": "Please input valid number for level, pos_x, and pos_y.".format(level, pos_x, pos_y)}, 400

        nav_node = NavNodeModel.find_nav_node_by_pos(**filters)
        if nav_node:
            return {"nav_node_result": nav_node.json()}
        return {"message": "Nav node not found"}, 404

    @jwt_required()
    def post(self, building, level, pos_x, pos_y):
        data = NavNode.parser.parse_args()
        try:
            filters = {
                'building': building,
                'level': int(level),
                'pos_x': int(pos_x),
                'pos_y': int(pos_y)
            }
        except:
            return {"message": "Please input valid number for level, pos_x, and pos_y."}, 400
        if NavNodeModel.find_nav_node_by_pos(**filters):
            return {"message": "A navigation point with building {}, level {}, x {}, y {} already exists.".format(building, str(level), str(pos_x), str(pos_y))}, 400

        fixed_data = {
            'building': building,
            'level': int(level),
            'pos_x': int(pos_x),
            'pos_y': int(pos_y),
            'default_exit_direction': data['default_exit_direction'],
            'special_type': data['special_type'],
            'location_id': None
        }
        if data['location_name']:
            found_location =  LocationModel.find_location_by_name(data['location_name'])
            if found_location:
                fixed_data['location_id'] = found_location.id
            else:
                return {"message": "No location with a location name {} found.".format(data['location_name'])}, 400

        nav_node = NavNodeModel(**fixed_data)
        try:
            nav_node.save_to_db()
            if fixed_data['location_id']:
                found_location.activate_armap()
        except:
            return {"message": "An error ocurred inserting the nav node."}, 500
        return {"nav_node_result": nav_node.json()}, 201
    
    @jwt_required()
    def delete(self, building, level, pos_x, pos_y):
        try:
            filters = {
                'building': building,
                'level': int(level),
                'pos_x': int(pos_x),
                'pos_y': int(pos_y)
            }
        except:
            return {"message": "Please input valid number for level, pos_x, and pos_y.".format(level, pos_x, pos_y)}, 400
        nav_node = NavNodeModel.find_nav_node_by_pos(**filters)
        if nav_node:
            nav_node.delete_from_db()
            return {"message": "Nav point deleted"}
        return {"message": "Nav point not found"}


class NavNodeList(Resource):
    def get(self):
        return {"nav_node_results": list(map(lambda x: x.json(), NavNodeModel.query.all()))}


class NavLink(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument("is_two_way", type=bool, required=True, help="Link needs to clarify if two-way allowed.")
    parser.add_argument("is_auth_needed", type=bool, required=True, help="Link needs to clarify if auth needed.")

    @jwt_required()
    def post(self, node_from_id, node_to_id):
        data = NavLink.parser.parse_args()
        try:
            filters = {
                'node_from_id': int(node_from_id),
                'node_to_id': int(node_to_id)
            }
        except:
            return {"message": "Please input valid number for node id(s)."}, 400
        if not data['is_two_way']:
            return {"message": "Currently, is_two_way must be True"}, 400
        if data['is_auth_needed']:
            return {"message": "Currently, is_auth_needed must be False"}, 400
        if NavLinkModel.find_navigation_link_by_nodes(**filters):
            return {"message": "A navigation link between node id {} and {} already exists.".format(node_from_id, node_to_id)}, 400
        if NavLinkModel.find_navigation_link_by_nodes(**filters):
            return {"message": "A navigation link between node id {} and {} already exists.".format(node_from_id, node_to_id)}, 400

        fixed_data = {
            'node_from_id': node_from_id,
            'node_to_id': node_to_id,
            'is_two_way': data['is_two_way'],
            'is_auth_needed': data['is_auth_needed']
        }

        node_from = NavNodeModel.find_nav_node_by_id(id=node_from_id);
        if not node_from:
            return {"message": "Node with id {} not exsit.".format(node_from_id)}, 400
        
        node_to = NavNodeModel.find_nav_node_by_id(id=node_to_id);
        if not node_to:
            return {"message": "Node with id {} not exsit.".format(node_to_id)}, 400

        if node_from.special_type in allowed_special_type and node_from.special_type == node_to.special_type:
            try:
                fixed_data['direction_2d'] = node_to.default_exit_direction
                fixed_data['distance'] = 1
                fixed_data['level_from'] = node_from.level
                fixed_data['level_to'] = node_to.level
            except:
                return {"message": "Special type node(s) have blank data. Can't calculate for the link information. Please fill in the missing data first."}, 500
        else:
            from_x = node_from.pos_x
            from_y = node_from.pos_y
            to_x = node_to.pos_x
            to_y = node_to.pos_y
            dis_x = to_x - from_x
            dis_y = to_y - from_y
            dis_2d = math.sqrt(dis_x ** 2 + dis_y ** 2 )
            fixed_data['distance'] = int(dis_2d) + 1

            if (dis_y == 0) and (dis_x > 0):
                fixed_data['direction_2d'] = 90
            elif (dis_y == 0) and (dis_x < 0):
                fixed_data['direction_2d'] = 270
            else:
                dir_180 = math.atan(dis_x / dis_y) / math.pi * 180
                fixed_data['direction_2d'] = int(dir_180)
            if (dis_y < 0):
                fixed_data['direction_2d'] += 180
            if fixed_data['direction_2d'] < 0:
                fixed_data['direction_2d'] += 360
            
            fixed_data['level_from'] = None
            fixed_data['level_to'] = None
        print(fixed_data)
        nav_link = NavLinkModel(**fixed_data)
        try:
            nav_link.save_to_db()
        except:
            return {"message": "An error ocurred inserting the nav link."}, 500
        return {"nav_link_result": nav_link.json()}, 201

    @jwt_required()
    def delete(self, node_from_id, node_to_id):
        try:
            filters = {
                'node_from_id': int(node_from_id),
                'node_to_id': int(node_to_id)
            }
        except:
            return {"message": "Please input valid number for node id(s)."}, 400
        nav_link = NavLinkModel.find_navigation_link_by_nodes(**filters)
        if nav_link:
            nav_link.delete_from_db()
            return {"message": "Nav link deleted"}
        return {"message": "Nav link not found"}

class NavLinkList(Resource):
    def get(self):
        return {"nav_link_results": list(map(lambda x: x.json(), NavLinkModel.query.all()))}

        
# Send API call to /find/<from_node_id>/<to_location_id> using GET method.
# No header/body needed.

# Output format:
# {
#     "path": [{
#         "node_to_id": int,   # the image name should contain the node id, so after scanning we can tell where user is
#         "node_to_location_name": str,  # optional, used for end point or friendly hints
#         "node_to_special_type": "elevator" or "stair",   # optional
#         "distance": int, # in feet
#         "to_floor": int or None,   # optional, 2 means to 2F
#         "direction_2d": int 0-359    # 0 - north, 90 - east
#     }, ]
# }

# Sample output file:
# {
#     "path":  [
#         {
#             "node_to_id": 134,
#             "node_to_special_type": "elevator"
#             "distance": 30,
#             "direction_2d": 180 # turn ?, go south to the elevator
#         },
#         {
#             "node_to_id": 135,
#             "node_to_level": 2,
#             "node_to_special_type": "elevator",
#             "distance": 0,
#             "direction_2d": 270,  # this is to tell next step turn
#             "to_floor": 2 # take the elevator up to 2F
#         },
#         {
#             "node_to_id": 199,
#             "distance": 10,
#             "direction_2d": 0 # after exiting the elevator, turn right, go north for 10 feets
#         },
#         {
#             "node_to_id": 109,
#             "node_to_location_name": "NQ 2435"
#             "distance": 200,
#             "direction_2d": 270 # turn left, go west for 200 feets
#         },
#     ]
# }

# The direction means the ones from point to point, not the actually facing direction: 0 - north, 90 - east, -1 - up or down.
# Client should deal with the user's current facing direction and correct the display if needed.
