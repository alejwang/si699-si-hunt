from extensions import db

class TagModel(db.Model):
    __tablename__ = "tags"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))
    priority = db.Column(db.Integer)
    
    def __init__(self, name, priority):
        # don"t need to pass id - the primary will be implemented automatically
        self.name = name
        self.priority = priority

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def json(self):
        json = {
            'id': self.id,
            'name' : self.name,
            'priority': self.priority
        }
        return json

    # @classmethod” is a decorator which runs the function underneath in a certain way. The method can be called without a particular instance of the class. If they don"t take self as parameter, you can call the method by class or instance.
    @classmethod
    def find_tag_by_name(cls, name):
        return cls.query.filter_by(name=name).first()

    # @classmethod
    # def find_user_by_id(cls, _id):
    #     return cls.query.filter_by(id=_id).first()


# event 1 - UX, 1st-year
# event 2 - Fun, International

# user 1 - UX, International