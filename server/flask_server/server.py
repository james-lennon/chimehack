from flask import Flask, request
from flask.ext.restful import Resource, Api, marshal_with, fields, abort
from flask_restful_swagger import swagger
from flask_server.api.twilio_rest import TwilioEndpoint
from flask_server.api.ios_rest import IOSEndpoint
from flask_server.api.ping import PingEndpoint

API_VERSION_NUMBER = '1.0'
API_VERSION_LABEL = 'v1'


class CustomFlaskApp(object):

    def __init__(self):
        self.app = Flask(__name__)
        custom_errors = {
            'JsonInvalidError': {
                'status': 500,
                'message': 'JSON format not valid'
            },
            'JsonRequiredError': {
                'status': 400,
                'message': 'JSON input required'
            }
        }
        self.api = swagger.docs(Api(self.app, errors=custom_errors), apiVersion=API_VERSION_NUMBER)
        
        self.api.add_resource(PingEndpoint, '/ping', endpoint='ping')
        self.api.add_resource(TwilioEndpoint, '/api/twilio/image_recognition', endpoint='twilio_image_recognition')
        self.api.add_resource(IOSEndpoint, '/api/ios/image_recognition', endpoint='ios_image_recognition')

    def run(self, *args, **kwargs):
        self.app.config['PROPAGATE_EXCEPTIONS'] = False
        self.app.run(*args, **kwargs)


def run_app(*args, **kwargs):
    app = CustomFlaskApp()
    app.run(*args, **kwargs)


if __name__ == '__main__':
    run_app(debug=True)
