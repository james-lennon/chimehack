from flask import request
from flask.ext.restful import Resource, Api, marshal_with, fields, abort
from flask_restful_swagger import swagger
from .errors import JsonRequiredError
from .errors import JsonInvalidError
from flask import Response
from twilio.twiml.messaging_response import MessagingResponse, Message
from twilio.rest import Client
from bs4 import BeautifulSoup
from clarifai import rest
from clarifai.rest import ClarifaiApp
from clarifai.rest import Image as ClImage
import requests
import resource
import ast
import base64

account_sid = "AC50b61476ea3fad16b180926f5821b942"
auth_token = "AC50b61476ea3fad16b180926f5821b942"
client = Client(account_sid, auth_token)

class ImageRecognitionEndpoint(Resource):
    def get(self):
        """
        REST: GET (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        image_url = request.values.get('MediaUrl0', None)
        image_name, sentence_example, giphy_example = getImageRecognition(image_url)

        resp = MessagingResponse()
        message_parts = []
        message_parts.append(Message().body("Vocab Term: " + image_name + " "))
        message_parts.append(Message().body("Sentence Example: " + sentence_example + " "))
        giphy_adjusted = giphy_example.replace("\\", "")
        message_parts.append(Message().media(giphy_adjusted))
        print(giphy_adjusted)

        for message_part in message_parts:
            resp.append(message_part)
        return Response(str(resp), mimetype='application/xml')

def getImageRecognition(image_url):
    """
    Return a tuple containing the term, example, translations, and gif

    params: image_url (string)
    returns: image_name, sentence_example, giphy_example (tuple)
    """
    clarifai_app = ClarifaiApp("pqVhRqjUHu0x0ouWhuRnzTVR9ve1XyqiqQ0hbzal", "sHUtxZ7NRCSfz75EHbTy6Q9fk9-PGCwe3FKth2cV")
    model = clarifai_app.models.get("general-v1.3")
    image = ClImage(url=image_url)
    response = model.predict([image])

    image_name = response['outputs'][0]['data']['concepts'][0]['name']
    sentence_example = getSentenceExampleFromImageName(image_name)
    giphy_example = getGiphy(image_name)
    return (image_name, t_image_name, sentence_example, t_sentence_example, giphy_example)

def getSentenceExampleFromImageName(image_name):
    """
    Return a sentence example given an image name

    params: image_name (string)
    returns: first_example (string)
    """
    url = "http://sentence.yourdictionary.com/" + str(image_name)
    rsrc = resource.RLIMIT_DATA
    soft, hard = resource.getrlimit(rsrc)
    resource.setrlimit(rsrc, (1024*1024*500, hard))
    r = requests.get(url)
    soup = BeautifulSoup(r.text, 'html.parser')
    output = str(soup.find(id="examples-ul-content"))
    start = output.find("li_content")+12
    end =  output.find("</div>")
    first_example = (output[start:end]).replace("<b>","").replace("</b>","")
    return first_example

def getGiphy(image_name):
    """
    Return the giphy URL (ending in .gif)

    params: image_name (string)
    returns: giphy (string)
    """
    url = "http://api.giphy.com/v1/gifs/search?q=" + str(image_name) + "&api_key=dc6zaTOxFJmzC"
    giphyR = requests.get(url)
    giphyR_dict = ast.literal_eval(giphyR.text)
    return giphyR_dict['data'][4]['images']['original']['url']