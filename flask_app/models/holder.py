from db import db

class HolderModel(db.Model):
    __tablename__ = 'holders'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))
    description = db.Column(db.String(255))
    email = db.Column(db.String(80))
    address = db.Column(db.String(80))
    leader_user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    is_official = db.Column(db.Boolean)

    user = db.relationship('UserModel')
    event = db.relationship('EventModel', lazy='dynamic')

    def __init__(self, name, description, email, address, leader_user_id, is_official):
        self.name = name
        self.description = description
        self.email = email
        self.address = address
        self.leader_user_id = leader_user_id
        self.is_official = is_official

    def json(self):
        json = {
            "name": self.name,
            "description": self.description,
            "email": self.email,
            "address": self.address,
            "leader_user_id": self.leader_user_id,
            "leader_user_name": self.user.name,
            "is_official": self.is_official,
            "events": list(map(lambda x: x.json(), self.event.all()))
        }
        return json

    @classmethod
    def find_holder_by_name(cls, name):
        return {'holder_result': cls.query.filter_by(name=name).first().json()}

    def find_all_holders(cls):
        return {'holder_results': list(map(lambda x: x.name, cls.query.order_by(id).all()))}
        # To-do here: the query order?
    
    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
