from db import db

class EventModel(db.Model):
    __tablename__ = 'events'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))
    description = db.Column(db.String(255))
    capacity = db.Column(db.Integer)
    holder_id = db.Column(db.Integer, db.ForeignKey('holders.id'))
    is_published = db.Column(db.Boolean)
    start_time = db.Column(db.DateTime)
    end_time = db.Column(db.DateTime)
    location_id = db.Column(db.Integer, db.ForeignKey('locations.id'))

    holder = db.relationship('HolderModel')
    location = db.relationship('LocationModel')

    def __init__(self, name, description, capacity, holder_id, is_published, start_time, end_time, location_id):
        self.name = name
        self.description = description
        self.capacity = capacity
        self.holder_id = holder_id
        self.is_published = is_published
        self.start_time = start_time
        self.end_time = end_time
        self.location_id = location_id

    def json(self):
        json = {
            "name": self.name,
            "description": self.description,
            "capacity": self.capacity,
            "holder_id": self.holder_id,
            "holder_name": self.holder.name,
            "start_time": self.start_time,
            "end_time": self.end_time,
            "location_id": self.location_id,
            "location_name": self.location.name,
            "location_is_armap_available": self.location.is_armap_available
        }
        return json

    @classmethod
    def find_event_by_name(cls, name):
        return {'event_result': cls.query.filter_by(name=name).first().json()}

    def find_all_events(cls):
        return {'event_results': list(map(lambda x: x.json(), cls.query.order_by(start_time).all()))}
    
    def find_upcoming_events(cls):
        return None
        # To-do here

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
