from db import db

class StudentModel(db.Model):
    __tablename__ = 'students'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))

    school_id = db.Column(db.Integer, db.ForeignKey('schools.id'))
    school = db.relationship('SchoolModel')

    def __init__(self, name, school_id):
        self.name = name
        self.school_id = school_id

    def json(self):
        return {'name': self.name, 'school': self.school.name}

    @classmethod
    def find_by_name(cls, name):
        return cls.query.filter_by(name=name).first()

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()
