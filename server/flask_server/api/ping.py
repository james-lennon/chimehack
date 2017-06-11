from flask import request
from flask.ext.restful import Resource, Api, marshal_with, fields, abort
from flask_restful_swagger import swagger
from .errors import JsonRequiredError
from .errors import JsonInvalidError
from flask import Response
from twilio.twiml.messaging_response import MessagingResponse, Message
from twilio.rest import Client
from .image_recognition import ImageRecognizer
from bs4 import BeautifulSoup


class PingEndpoint(Resource):
    def get(self):
        """
        REST: GET (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        print "pinged!"
        return Response('{"msg":"pinged!"}', mimetype='application/xml')
