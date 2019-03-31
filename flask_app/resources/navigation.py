from extensions import jwt
from flask_jwt_extended import JWTManager, jwt_required
from flask_restplus import Namespace, Resource
import math
from helper import dijkstra
from models.navigation import NavNodeModel, NavLinkModel
from models.location import LocationModel

api = Namespace('Navigation', description='Links and nodes for path finding and indoor location detection')



allowed_special_type = ['elevator', 'stair', 'outdoor']
vertical_move = ['elevator', 'stair']

@api.route('nav/node/<string:building>/<string:level>/<string:pos_x>/<string:pos_y>')
@api.param('building', 'Building name')
@api.param('level', 'Level number')
@api.param('pos_x', 'X cor')
@api.param('pos_y', 'Y cor')
class NavNode(Resource):

    parser = api.parser()
    parser.add_argument("default_exit_direction", type=int, required=True, help="Point needs a default exit direction.")
    parser.add_argument("special_type", help="options: stair/elevator/outdoor", type=lambda s: s if s in allowed_special_type else None)
    parser.add_argument("location_name", type=lambda s: s if s else None)

    # my_fields = api.model('NavNodeInput', {
    #     'default_exit_direction': fields.Integer(description='the direction to exit the room/elevator/stair, use 0-359', required=True, example="0", min=0, max=359),
    #     'special_type': fields.String(enum=['stair', 'elevator', 'outdoor']),
    #     'location_name': fields.String(description='the room name if room exsits', example="NQ 2435")
    # })

    @api.doc(security=None, responses={200:'OK', 404: 'Not found'})
    def get(self, building, level, pos_x, pos_y):
        """displays a nav point's details"""
        try:
            filters = {
                'building': building,
                'level': int(level),
                'pos_x': int(pos_x),
                'pos_y': int(pos_y)
            }
        except:
            return {"message": "Please input valid number for level, pos_x, and pos_y."}, 404

        nav_node = NavNodeModel.find_nav_node_by_pos(**filters)
        if nav_node:
            return {"nav_node_result": nav_node.json()}, 200
        return {"message": "Nav node not found"}, 404


    @api.doc(security='JWT', responses={201:'Created', 400: 'Bad request: item already exsits', 500: 'Database internal error', 401:'No authorization'})
    @jwt_required
    @api.expect(parser)
    # @api.expect(my_fields)
    def post(self, building, level, pos_x, pos_y):
        """adds a new nav point"""
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


    @api.doc(security='JWT', responses={204:'No content returned', 404: 'Not found', 401:'No authorization'})
    @jwt_required
    def delete(self, building, level, pos_x, pos_y):
        """deletes a location by b/l/x/y"""
        try:
            filters = {
                'building': building,
                'level': int(level),
                'pos_x': int(pos_x),
                'pos_y': int(pos_y)
            }
        except:
            return {"message": "Please input valid number for level, pos_x, and pos_y.".format(level, pos_x, pos_y)}, 404
        nav_node = NavNodeModel.find_nav_node_by_pos(**filters)
        if nav_node:
            nav_node.delete_from_db()
            return {"message": "Nav point deleted"}, 204
        return {"message": "Nav point not found"}, 404



@api.route('nav/nodes')
class NavNodeList(Resource):
    @api.doc(security=None, responses={200:'OK'})
    def get(self):
        """returns a list of nav nodes"""
        return {"nav_node_results": list(map(lambda x: x.json(), NavNodeModel.query.all()))}



@api.route('nav/link/<string:node_from_id>/<string:node_to_id>')
@api.param('node_from_id', 'Start node ID number')
@api.param('node_to_id', 'End node ID number')
class NavLink(Resource):

    parser = api.parser()
    parser.add_argument("is_two_way", type=bool, required=True, default=True, help="Link needs to clarify if two-way allowed.")
    parser.add_argument("is_auth_needed", type=bool, required=True, default=False, help="Link needs to clarify if auth needed.")


    @api.doc(security='JWT', responses={201:'Created', 400: 'Bad request: item already exsits', 500: 'Database internal error', 401:'No authorization'})
    @jwt_required
    @api.expect(parser)
    def post(self, node_from_id, node_to_id):
        """adds a new nav link"""
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
            data['is_auth_needed'] = False
            # return {"message": "Currently, is_auth_needed must be False"}, 400
        if NavLinkModel.find_nav_link_by_nodes(**filters):
            return {"message": "A navigation link between node id {} and {} already exists.".format(node_from_id, node_to_id)}, 400
        if NavLinkModel.find_nav_link_by_nodes(**filters):
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

        from_x = node_from.pos_x
        from_y = node_from.pos_y
        to_x = node_to.pos_x
        to_y = node_to.pos_y
        dis_x = to_x - from_x
        dis_y = to_y - from_y
        if (dis_x == 0) and (dis_y == 0):
            fixed_data['distance'] = 1
            fixed_data['direction_2d'] = -1
        else:
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

        # fixed_data['level_from'] = None
        # fixed_data['level_to'] = None
        # fixed_data['default_exit_direction_from'] = node_from.default_exit_direction
        # fixed_data['default_exit_direction_to'] = node_to.default_exit_direction

        # if node_from.special_type in allowed_special_type and node_from.special_type == node_to.special_type:
        #     try:
        #         fixed_data['direction_2d'] = -1
        # #         fixed_data['level_from'] = node_from.level
        # #         fixed_data['level_to'] = node_to.level
        #     except:
        #         return {"message": "Special type node(s) have blank data. Can't calculate for the link information. Please fill in the missing data first."}, 500

        nav_link = NavLinkModel(**fixed_data)
        try:
            nav_link.save_to_db()
        except:
            return {"message": "An error ocurred inserting the nav link."}, 500
        return {"nav_link_result": nav_link.json()}, 201


    @api.doc(security='JWT', responses={204:'No content returned', 404: 'Not found', 401:'No authorization'})
    @jwt_required
    @api.expect(parser)
    def delete(self, node_from_id, node_to_id):
        """deletes a connected path between a/b"""
        try:
            filters = {
                'node_from_id': int(node_from_id),
                'node_to_id': int(node_to_id)
            }
        except:
            return {"message": "Please input valid number for node id(s)."}, 400
        nav_link = NavLinkModel.find_nav_link_by_nodes(**filters)
        if nav_link:
            nav_link.delete_from_db()
            return {"message": "Nav link deleted"}
        return {"message": "Nav link not found"}


@api.route('nav/links')
class NavLinkList(Resource):
    @api.doc(security=None, responses={200:'OK'})
    def get(self):
        """returns a list of nav links"""
        return {"nav_link_results": list(map(lambda x: x.json(), NavLinkModel.query.all()))}


@api.route('nav/path')
class NavFindPath(Resource):
    
    parser = api.parser()
    parser.add_argument("start_node", type=int, location='args', required=False, help="start node id")
    parser.add_argument("end_node", type=int, location='args', required=False, help="end node id")
    parser.add_argument("start_location", type=int, location='args', required=False, help="if start_node is blank, please fill in start location id")
    parser.add_argument("end_location", type=int, location='args', required=False, help="if end_node is blank, please fill in end location id")

    @api.doc(security=None, responses={200:'OK', 400: 'Bad request: item already exsits', 404: 'Not found'})
    @api.expect(parser)
    def get(self):
        """returns steps for indoor navigation"""

        data = NavFindPath.parser.parse_args()
        (start_node, end_node) = (0, 0)
        if data["start_node"]:
            start_node = NavNodeModel.find_nav_node_by_id(data["start_node"])
        elif data["start_location"]:
            start_node = NavNodeModel.find_nav_node_by_location_id(data["start_location"])
        if data["end_node"]:
            end_node = NavNodeModel.find_nav_node_by_id(data["end_node"])
        elif data["end_location"]:
            end_node = NavNodeModel.find_nav_node_by_location_id(data["end_location"])
        
        if not start_node or not end_node:
            return {"message": "Node(s) not exsits"}, 400

        if start_node.id == end_node.id:
            return {"message": "You're already here"}, 400

        print(start_node.id, end_node.id)

        edges = list(map(lambda x: x.json(), NavLinkModel.query.all()))
        heap = dijkstra.run(edges, int(start_node.id), int(end_node.id))
        if heap == float("inf"):
            return {"message": "No path found"}, 404

        instructions = []
        heap = heap[1]
        current_step_to = heap[0]  #3
        while heap[1]:
            heap = heap[1]  #2,1
            current_step_from = heap[0] #2

            filters = {'node_from_id': current_step_from, 'node_to_id': current_step_to}
            link = NavLinkModel.find_nav_link_by_nodes(**filters)
            if link:
                step_instruction = {
                    "node_to_id": link.node_to_id,
                    "distance": link.distance,
                    "direction_2d": link.direction_2d,
                    "to_level": link.node_to.level,
                    "default_exit_direction": link.node_to.default_exit_direction
                }
                # if link.direction_2d == -1:
                #     step_instruction["direction_2d"] = link.node_to.default_exit_direction
                if link.node_to.location:
                    step_instruction["node_to_location_name"] = link.node_to.location.name
                # else:
                #     step_instruction.pop('node_to_location_name', None)
                if link.node_to.special_type:
                    step_instruction["node_to_special_type"] = link.node_to.special_type
                    # if link.node_to.special_type in vertical_move:
                    #     step_instruction["to_floor"] = link.node_to.level
                # else:
                #     step_instruction.pop('node_to_special_type', None)
            else:
                filters = {'node_from_id': current_step_to, 'node_to_id': current_step_from}
                link = NavLinkModel.find_nav_link_by_nodes(**filters)
                step_instruction = {
                    "node_to_id": link.node_from_id,
                    "distance": link.distance,
                    "direction_2d": (link.direction_2d + 180)%360 if link.direction_2d > -1 else -1,
                    "to_level": link.node_from.level,
                    "default_exit_direction": link.node_from.default_exit_direction
                }
                # if link.direction_2d == -1:
                #     step_instruction["direction_2d"] = link.node_from.default_exit_direction
                if link.node_from.location:
                    step_instruction["node_to_location_name"] = link.node_from.location.name
                # else:
                #     step_instruction.pop('node_to_location_name', None)
                if link.node_from.special_type:
                    step_instruction["node_to_special_type"] = link.node_from.special_type
                    # if link.node_from.special_type in vertical_move:
                    #     step_instruction["to_floor"] = link.node_from.level
                # else:
                #     step_instruction.pop('node_to_special_type', None) 
            
            instructions.insert(0, step_instruction)
            current_step_to = current_step_from

        if len(instructions) <= 2:
            return  {"path": instructions}, 200

        fixed_instructions = instructions[:1]
        for each in instructions[1:]:
            
            if ((fixed_instructions[-1]["direction_2d"] == -1) and (not each["direction_2d"] == -1)) or ((not fixed_instructions[-1]["direction_2d"] == -1) and (each["direction_2d"] == -1)):
                fixed_instructions.append(each)
                continue
            if ("node_to_special_type" in each) and ("node_to_special_type" in fixed_instructions[-1]):
                if not each["node_to_special_type"] == fixed_instructions[-1]["node_to_special_type"]:
                    fixed_instructions.append(each)
                    continue
            if ((fixed_instructions[-1]["direction_2d"] == -1) and (each["direction_2d"] == -1)):
                fixed_instructions[-1]["node_to_id"] = each["node_to_id"]
                fixed_instructions[-1]["distance"] += each["distance"]
                if "node_to_location_name" in each:
                    fixed_instructions[-1]["node_to_location_name"] = each["node_to_location_name"]
                else:
                    fixed_instructions[-1].pop("node_to_location_name", None)
                if "node_to_special_type" in each:
                    fixed_instructions[-1]["node_to_special_type"] = each["node_to_special_type"]
                else:
                    fixed_instructions[-1].pop("node_to_special_type", None)
                if "to_floor" in each:
                    fixed_instructions[-1]["to_floor"] = each["to_floor"]
                else:
                    fixed_instructions[-1].pop("to_floor", None)
                
            elif (each["direction_2d"] < fixed_instructions[-1]["direction_2d"] + 10) and (each["direction_2d"] >= fixed_instructions[-1]["direction_2d"] - 10):
                fixed_instructions[-1]["node_to_id"] = each["node_to_id"]
                fixed_instructions[-1]["distance"] += each["distance"]
                if "node_to_location_name" in each:
                    fixed_instructions[-1]["node_to_location_name"] = each["node_to_location_name"]
                else:
                    fixed_instructions[-1].pop("node_to_location_name", None)
                if "node_to_special_type" in each:
                    fixed_instructions[-1]["node_to_special_type"] = each["node_to_special_type"]
                else:
                    fixed_instructions[-1].pop("node_to_special_type", None)
                if "to_floor" in each:
                    fixed_instructions[-1]["to_floor"] = each["to_floor"]
                else:
                    fixed_instructions[-1].pop("to_floor", None)
            else:
                fixed_instructions.append(each)

        return {"path": fixed_instructions}, 200
        

# Send API call to /find/<from_node_id>/<to_node_id> using GET method.
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
