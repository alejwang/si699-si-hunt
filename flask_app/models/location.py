from db import db

class LocationModel(db.Model):
    __tablename__ = "locations"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))
    capacity = db.Column(db.Integer)
    is_armap_available = db.Column(db.Boolean)

    def __init__(self, name, capacity=0, is_armap_available=False):
        self.name = name
        self.capacity = capacity
        self.is_armap_available = is_armap_available

    def json(self):
        json = {
            "name": self.name,
            "capacity": self.capacity,
            "is_armap_available": self.is_armap_available
        }
        return json

    @classmethod
    def find_location_by_id(cls, id):
        return cls.query.filter_by(id=id).first()

    @classmethod
    def find_location_by_name(cls, name):
        return cls.query.filter_by(name=name).first()

    # def find_all_locations(cls):
    #     return {"location_results": list(map(lambda x: x.json(), cls.query.order_by(id).all()))}
    #     # To-do here: the query order?
    
    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
