from extensions import db

class NavNodeModel(db.Model):
    __tablename__ = "nav_nodes"

    id = db.Column(db.Integer, primary_key=True)
    building = db.Column(db.String(80))
    level = db.Column(db.Integer)
    pos_x = db.Column(db.Float)
    pos_y = db.Column(db.Float)
    special_type = db.Column(db.String(80))
    default_exit_direction = db.Column(db.Integer)
    location_id = db.Column(db.Integer, db.ForeignKey("locations.id"))

    location = db.relationship("LocationModel", backref="nav_node")

    def __init__(self, building, level, pos_x, pos_y, default_exit_direction, special_type, location_id = None):
        self.building = building
        self.level = level
        self.pos_x = pos_x
        self.pos_y = pos_y
        self.special_type = special_type
        self.default_exit_direction = default_exit_direction
        self.location_id = location_id

    def json(self):
        json = {
            "id": self.id,
            "building": self.building,
            "level": self.level,
            "pos_x": self.pos_x,
            "pos_y": self.pos_y,
            "default_exit_direction": self.default_exit_direction
        }
        if self.special_type:
            json["special_type"] = self.special_type
        if self.location:
            json["location_id"] = self.location_id
            json["location_name"] = self.location.name
        return json

    @classmethod
    def find_nav_node_by_id(cls, id):
        return cls.query.filter_by(id=id).first()

    @classmethod
    def find_nav_node_by_location_id(cls, id):
        return cls.query.filter_by(location_id=id).first()

    @classmethod
    def find_nav_node_by_pos(cls, building, level, pos_x, pos_y):
        filters = {'building': building, 'level': level, 'pos_x': pos_x, 'pos_y': pos_y}
        return cls.query.filter_by(**filters).first()
    
    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()


class NavLinkModel(db.Model):
    __tablename__ = "nav_links"

    id = db.Column(db.Integer, primary_key=True)
    node_from_id = db.Column(db.Integer, db.ForeignKey("nav_nodes.id"))
    node_to_id = db.Column(db.Integer, db.ForeignKey("nav_nodes.id"))
    distance = db.Column(db.Integer)
    direction_2d = db.Column(db.Integer)
    is_two_way = db.Column(db.Boolean)
    is_auth_needed = db.Column(db.Boolean)

    node_from = db.relationship("NavNodeModel", foreign_keys=[node_from_id])
    node_to = db.relationship("NavNodeModel", foreign_keys=[node_to_id])

    def __init__(self, node_from_id, node_to_id, distance, direction_2d, is_two_way, is_auth_needed):
        self.node_from_id = node_from_id
        self.node_to_id = node_to_id
        self.direction_2d = direction_2d
        self.distance = distance
        self.is_two_way = is_two_way
        self.is_auth_needed = is_auth_needed
        
    def json(self):
        json = {
            "id": self.id,
            "node_from_id": self.node_from_id,
            "node_to_id": self.node_to_id,
            "distance": self.distance,
            "direction_2d": self.direction_2d,
            "is_two_way": self.is_two_way,
            "is_auth_needed": self.is_auth_needed
        }
        return json

    @classmethod
    def find_nav_link_by_id(cls, id):
        return cls.query.filter_by(id=id).first()

    @classmethod
    def find_nav_link_by_nodes(cls, node_from_id, node_to_id):
        filters = {'node_from_id': node_from_id, 'node_to_id': node_to_id}
        return cls.query.filter_by(**filters).first()

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
