from db import db

class EventModel(db.Model):
    __tablename__ = 'event'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))
    description = db.Column(db.String(255))
    capacity = db.Column(db.Integer)
    holder_id = db.Column(db.Integer, db.ForeignKey('schools.id'))
