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

account_sid = "AC50b61476ea3fad16b180926f5821b942"
auth_token = "AC50b61476ea3fad16b180926f5821b942"
client = Client(account_sid, auth_token)
image_recognizer = ImageRecognizer()


class TwilioEndpoint(Resource):
    def get(self):
        """
        REST: GET (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        image_url = request.values.get('MediaUrl0', None)
        target_language = 'es'
        image_recognition = image_recognizer.getImageRecognition(image_url, target_language)
        image_name, t_image_name, definition, t_definition, sentence_example, t_sentence_example, giphy_example = image_recognition

        resp = MessagingResponse()
        message_parts = []
        message_parts.append(Message().body("Vocab Term: " + image_name + " "))
        message_parts.append(Message().body("Translated Term: " + t_image_name + " "))
        message_parts.append(Message().body("Definition: " + definition + " "))
        message_parts.append(Message().body("Translated Definition: " + t_definition + " "))
        message_parts.append(Message().body("Sentence Example: " + sentence_example + " "))
        message_parts.append(Message().body("Translated Sentence: " + t_sentence_example + " "))
        message_parts.append(Message().media(giphy_example))

        for message_part in message_parts:
            resp.append(message_part)
        return Response(str(resp), mimetype='application/xml')
