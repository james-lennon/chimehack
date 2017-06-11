from flask import request
from flask.ext.restful import Resource, Api, marshal_with, fields, abort
from flask_restful_swagger import swagger
from .errors import JsonRequiredError
from .errors import JsonInvalidError
from flask import Response
from bs4 import BeautifulSoup


class IOSEndpoint(Resource):
    def post(self):
        """
        REST: GET (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        image_url = request.values.get('MediaUrl0', None)
        image_name, t_image_name, sentence_example, t_sentence_example, giphy_example = getImageRecognition(image_url)

        resp = MessagingResponse()
        message_parts = []
        message_parts.append(Message().body("Vocab Term: " + image_name + " "))
        message_parts.append(Message().body("Translated Term: " + t_image_name + " "))
        message_parts.append(Message().body("Sentence Example: " + sentence_example + " "))
        message_parts.append(Message().body("Translated Sentence: " + t_sentence_example + " "))
        giphy_adjusted = giphy_example.replace("\\", "")
        message_parts.append(Message().media(giphy_adjusted))
        print(giphy_adjusted)

        for message_part in message_parts:
            resp.append(message_part)
        return Response(str(resp), mimetype='application/xml')