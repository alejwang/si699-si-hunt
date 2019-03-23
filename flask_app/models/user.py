from extensions import db
from models.tag import TagModel

tags_users = db.Table('tags_users',
    db.Column('tag_id', db.Integer, db.ForeignKey('tags.id'), primary_key=True),
    db.Column('user_id', db.Integer, db.ForeignKey('users.id'), primary_key=True)
)

class UserModel(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80))
    password = db.Column(db.String(80))
    fullname = db.Column(db.String(80))
    description = db.Column(db.String(80))

    tags = db.relationship('TagModel', secondary=tags_users, lazy='subquery',
        backref=db.backref('UserModel', lazy=True))
    # is_administrator = db.Column(db.Integer, db.ForeignKey("holders.id"))

    # holder = db.relationship("HolderModel", back_populates="administrator", primaryjoin="HolderModel.id == UserModel.is_administrator")

    def __init__(self, username, password):
        # don"t need to pass id - the primary will be implemented automatically
        self.username = username
        self.password = password
        self.fullname = "Hunter"
        self.description = ""
        self.is_administrator = 0

    def json(self):
        json = {
            'username': self.username,
            'tags': [tag.name for tag in self.tags]
        }
        return json

    def set_profile(self, tags_list, old_password = None, new_password = None, fullname = None, description = None):
        self.tags = []
        for tag_name in tags_list:
            tag = TagModel.find_tag_by_name(tag_name)
            if tag :
                self.tags.append(tag)

    def set_as_administrator(self, is_administrator):
        return None
        # To-do here: set name, description and is_administrator

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()
    
    def update_to_db(self):
        db.session.commit()

    # @classmethod” is a decorator which runs the function underneath in a certain way. The method can be called without a particular instance of the class. If they don"t take self as parameter, you can call the method by class or instance.
    @classmethod
    def find_user_by_username(cls, username):
        return cls.query.filter_by(username=username).first()

    @classmethod
    def find_user_by_id(cls, _id):
        return cls.query.filter_by(id=_id).first()
