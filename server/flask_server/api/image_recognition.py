from flask import request
from flask.ext.restful import Resource, Api, marshal_with, fields, abort
from flask_restful_swagger import swagger
from .errors import JsonRequiredError
from .errors import JsonInvalidError
from flask import Response
from twilio.twiml.messaging_response import MessagingResponse, Message
from twilio.rest import Client
from bs4 import BeautifulSoup
import requests
import resource
import ast

account_sid = "AC50b61476ea3fad16b180926f5821b942"
auth_token = "AC50b61476ea3fad16b180926f5821b942"
client = Client(account_sid, auth_token)

class ImageRecognitionEndpoint(Resource):
    # @swagger.operation(
    #     responseClass=DummyResult.__name__,
    #     nickname='dummy')

    def get(self):
        """Return a DummyResult object

        Lightweight response to let us confirm that the server is on-line"""
        # from_number = request.values.get('From', None)
        image_url = request.values.get('MediaUrl0', None)
        print(request.values)
        # msg = Message().body("Hello, Mobile Monkey").media("https://demo.twilio.com/owl.png")


        # resp = MessagingResponse().message("Hello, Mobile Monkey")
        # message = client.api.account.messages.create(to=from_number,
        #                                              from_="+14157671750",
        #                                              body="Hello there!")
        return Response(str(resp), mimetype='application/xml')

def getImageRecognition(image_url):
    app = ClarifaiApp("pqVhRqjUHu0x0ouWhuRnzTVR9ve1XyqiqQ0hbzal", "sHUtxZ7NRCSfz75EHbTy6Q9fk9-PGCwe3FKth2cV")
    model = app.models.get("general-v1.3")
    image = ClImage(url=image_url)
    model.predict([image])

    objectname = response['outputs'][0]['data']['concepts'][0]['name']
    url = "http://sentence.yourdictionary.com/" + str(objectname)

    rsrc = resource.RLIMIT_DATA
    soft, hard = resource.getrlimit(rsrc)
    resource.setrlimit(rsrc, (1024*1024*500, hard))

    r = requests.get(url)
    soup = BeautifulSoup(r.text, 'html.parser')
    output = str(soup.find(id="examples-ul-content"))
    start = output.find("li_content")+12
    end =  output.find("</div>")
    firstexample = output[start:end]
    firstexample = firstexample.replace("<b>","")
    firstexample = firstexample.replace("</b>","")
    print firstexample
    return objectname

def getGiphy(objectname):
    url = "http://api.giphy.com/v1/gifs/search?q=" + str(objectname) + "&api_key=dc6zaTOxFJmzC"
    r = requests.get(url)
    mydict = ast.literal_eval(r.text)
    giphy =  mydict['data'][0]['embed_url']
    return giphy