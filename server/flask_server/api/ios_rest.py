from flask import request, jsonify
from flask.ext.restful import Resource, Api, marshal_with, fields, abort
from flask_restful_swagger import swagger
from .errors import JsonRequiredError
from .errors import JsonInvalidError
from flask import Response
from bs4 import BeautifulSoup
from .image_recognition import ImageRecognizer

class IOSEndpoint(Resource):
    def post(self):
        """
        REST: POST (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        image_url = request.values.form['media_url']
        target_language = request.values.form['target_language']
        image_recognition = getImageRecognition(image_url, target_language, isBase64=True)
        image_recognition_fields = ['vocab', 't_vocab', 'definition', 't_definition', 'sentence', 't_sentence', 'giphy_url']
        result = dict(zip(image_recognition_fields, image_recognition))
        return jsonify(result)
