from flask import request, jsonify
from flask.ext.restful import Resource, Api, marshal_with, fields, abort
from flask_restful_swagger import swagger
from .errors import JsonRequiredError
from .errors import JsonInvalidError
from flask import Response
from bs4 import BeautifulSoup
from .image_recognition import ImageRecognizer
import json
import os

image_recognizer = ImageRecognizer()

class IOSEndpoint(Resource):
    def post(self):
        """
        REST: POST (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        image_url = cleanJamesShit(request.values['media_url'])
        target_language = cleanJamesShit(request.values['target_language'])
        
        dir_path = os.path.dirname(os.path.realpath(__file__))
        with open(os.path.join(dir_path, 'language_codes.json')) as data_file:
            language_codes = json.load(data_file)
        target_language = language_codes[target_language]

        image_recognition = image_recognizer.getImageRecognition(image_url, target_language, isBase64=True)
        image_recognition_fields = ['vocab', 't_vocab', 'definition', 't_definition', 'sentence', 't_sentence', 'giphy_url']
        result = dict(zip(image_recognition_fields, image_recognition))
        return jsonify(result)

def cleanJamesShit(some_string):
    return some_string.replace('Optional("', '').replace('")', '')