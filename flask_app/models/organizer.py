from extensions import db

class OrganizerModel(db.Model):

    __tablename__ = "organizers"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))
    description = db.Column(db.String(255))
    email = db.Column(db.String(80))
    address = db.Column(db.String(80))
    # administrator_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    is_official = db.Column(db.Boolean)

    # administrator = db.relationship("UserModel", back_populates="holder", primaryjoin="UserModel.id == HolderModel.administrator_id")
    # event = db.relationship("EventModel")
    # check http://flask-sqlalchemy.pocoo.org/2.3/models/ to decide the lazy parameter
    # check backref here: https://docs.sqlalchemy.org/en/latest/orm/basic_relationships.html#one-to-one

    def __init__(self, name, description, email, address, is_official):
    # def __init__(self, name, description, email, address, administrator_id, is_official):
        self.name = name
        self.description = description
        self.email = email
        self.address = address
        # self.administrator_id = administrator_id
        self.is_official = is_official

    def json(self):
        json = {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "email": self.email,
            "address": self.address,
            # "administrator_id": self.administrator_id,
            # "administrator_name": self.administrator.name,
            "is_official": self.is_official
            # "events": list(map(lambda x: x.json(), self.event.all()))
        }
        return json

    @classmethod
    def find_organizer_by_id(cls, id):
        return cls.query.filter_by(id=id).first()

    @classmethod
    def find_organizer_by_name(cls, name):
        return cls.query.filter_by(name=name).first()
    
    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
