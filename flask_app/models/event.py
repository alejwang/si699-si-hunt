from extensions import db
from datetime import datetime
from models.tag import TagModel


tags_events = db.Table('tags_events',
    db.Column('tag_id', db.Integer, db.ForeignKey('tags.id'), primary_key=True),
    db.Column('event_id', db.Integer, db.ForeignKey('events.id'), primary_key=True)
)

class EventModel(db.Model):
    __tablename__ = "events"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))
    description = db.Column(db.String(255))
    capacity = db.Column(db.Integer)
    organizer_id = db.Column(db.Integer, db.ForeignKey("organizers.id"))
    start_time = db.Column(db.DateTime)
    end_time = db.Column(db.DateTime)
    location_id = db.Column(db.Integer, db.ForeignKey("locations.id"))
    is_published = db.Column(db.Boolean, default=0)
    pub_date = db.Column(db.DateTime, default=datetime.utcnow)

    organizer = db.relationship("OrganizerModel", backref="events")
    location = db.relationship("LocationModel", backref="events")
    tags = db.relationship('TagModel', secondary=tags_events, lazy='subquery',
        backref=db.backref('EventModel', lazy=True))
    # backref -> https://docs.sqlalchemy.org/en/latest/orm/basic_relationships.html#many-to-one

    def __init__(self, name, description, capacity, organizer_id, start_time, end_time, location_id, is_published, pub_date, tags_list):
        self.name = name
        self.description = description
        self.capacity = capacity
        self.organizer_id = organizer_id
        self.start_time = start_time
        self.end_time = end_time
        self.location_id = location_id
        self.is_published = is_published
        self.pub_date = pub_date
        self.tags = []
        if tags_list:
            for tag_name in tags_list:
                tag = TagModel.find_tag_by_name(tag_name)
                if tag :
                    self.tags.append(tag)
                

    def json(self):
        json = {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "capacity": self.capacity,
            "organizer_id": self.organizer_id,
            "organizer_name": self.organizer.name,
            "start_time": datetime.strftime(self.start_time, "%Y-%m-%d %H:%M"),
            "end_time": datetime.strftime(self.end_time, "%Y-%m-%d %H:%M"),
            "location_id": self.location_id,
            "location_name": self.location.name,
            "location_is_armap_available": self.location.is_armap_available,
            "is_published": self.is_published,
            "pub_date": datetime.strftime(self.pub_date, "%Y-%m-%d %H:%M"),
            'tags': [tag.name for tag in self.tags]
        }
        return json

    @classmethod
    def find_event_by_id(cls, id):
        return cls.query.filter_by(id=id).first()

    @classmethod
    def find_event_by_name(cls, name):
        return cls.query.filter_by(name=name).first()
        # return {"event_result": cls.query.filter_by(name=name).first().json()}

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
