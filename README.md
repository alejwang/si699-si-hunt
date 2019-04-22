SI699 NO NAME Project by TEAM1
================================

This project demos event hunter and indoor navigation inside NQ.

Contact si699-hunt@umich.edu



Getting started
---------------

First you'll need to get the source of the project. Do this by cloning the whole repository:

```bash
# Get the example project code
git clone https://github.com/alejwang/si699-fapp-sprints.git
```

It is good idea to create a virtual environment for this project so you don't need to install unnecessary packages in your global environment. 

```bash
# Create a virtualenv 
python3 -m venv venv
source venv/bin/activate
```

Then we need install our dependencies:

```bash
pip install -r si699-fapp-sprints/docs/requirements.txt
```

Now the following command will setup the database, and start the server:

```bash
cd si699-fapp-sprints/flask_app
python app.py

```


Now head on over to
[http://127.0.0.1:5000/events/](http://127.0.0.1:5000/events/)
and run some queries!

You can also use the Postman Collections to see some preset APIs.
