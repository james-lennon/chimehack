from flask import request
from flask.ext.restful import Resource, Api, marshal_with, fields, abort
from flask_restful_swagger import swagger
from .errors import JsonRequiredError
from .errors import JsonInvalidError
from flask import Response
import requests
import json
from subprocess import Popen, PIPE
import base64
import os
from PIL import Image
from io import BytesIO
import base64
import time

baseUrl = 'https://api.mlab.com/api/1/databases/chimehack'
headers = {'content-type': 'application/json'}

class ChallengeEndpoint(Resource):
    def post(self):
        """
        REST: GET (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        base64Image = request.values.get('base64Image', None)
        userLabel = request.values.get('userLabel', None)
        fromUser = request.values.get('fromUser', None)
        toUsers = request.values.get('toUsers', None)

        with open("data/temp.jpg", "wb") as fh:
            fh.write(base64.b64decode(base64Image))

        while os.stat("data/temp.jpg").st_mtime > os.stat("results.txt").st_mtime:
            time.sleep(.2)

        with open("results.txt", "r") as f:
            correctLabels = [ line for line in f.readlines() if len(line) > 0 ]

        challengedata = json.dumps(
            {
                'base64Image': base64Image,
                'userLabel': userLabel,
                'correctLabels': correctLabels,
                'fromUser': fromUser,
                'toUsers': toUsers,
                'completed': 'False',
                'points': len(userLabel)
            }
        )
        r = requests.post(baseUrl + '/collections/challenges?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP', data=challengedata, headers=headers)

        return Response(str(r.text), mimetype='application/json')

    def get(self):
        """
        REST: GET (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        username = request.values.get('username', None)

        challenges = []

        r = requests.get(baseUrl + '/collections/challenges?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP')
        for t in eval(r.text):
            if username in t['toUsers'].split(',') or username == t['fromUser']:
                challenges.append(t)

        return Response(json.dumps(challenges), mimetype='application/json')

    def put(self):
        """
        REST: GET (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        challengeId = request.values.get('challengeId', None)
        username = request.values.get('username', None)
        label = request.values.get('label', None)

        challengedata = json.dumps({ "$set" : { "completed" : 'True' } })
        r = requests.put(baseUrl + '/collections/challenges/' + challengeId + '?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP', data=challengedata, headers=headers)
        challenge = eval(r.text)

        userIdsToGivePoints = []
        r = requests.get(baseUrl + '/collections/users?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP')
        for t in eval(r.text):
            if t['username'] == username and label in challenge['correctLabels'].split(','):
                userIdsToGivePoints.append({
                        'id': t['_id']['$oid'],
                        'score': int(t['score']) + int(challenge['points'])
                    })
            if t['username'] == challenge['fromUser'] and challenge['userLabel'] in challenge['correctLabels'].split(','):
                userIdsToGivePoints.append({
                        'id': t['_id']['$oid'],
                        'score': int(t['score']) + int(challenge['points'])
                    })
        for user in userIdsToGivePoints:
            scoredata = json.dumps({ "$set" : { "score" : user['score'] } })
            r = requests.put(baseUrl + '/collections/users/' + user['id'] + '?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP', data=scoredata, headers=headers)

        return Response(str(r.text), mimetype='application/json')
