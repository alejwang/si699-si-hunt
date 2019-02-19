from db import db

class SchoolModel(db.Model):
    __tablename__ = 'schools'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))

    students = db.relationship('StudentModel', lazy='dynamic') #if lazy='dynamic', students is a query builder

    def __init__(self, name):
        self.name = name

    def json(self):
        return {'name': self.name, 'students': list(map(lambda x: x.json(), self.students.all()))}

    @classmethod
    def find_by_name(cls, name):
        return cls.query.filter_by(name=name).first()

    def find_by_name(cls, id):
        return cls.query.filter_by(id=id).first()

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
