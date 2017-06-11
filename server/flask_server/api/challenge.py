from flask import request
from flask.ext.restful import Resource, Api, marshal_with, fields, abort
from flask_restful_swagger import swagger
from .errors import JsonRequiredError
from .errors import JsonInvalidError
from flask import Response
import requests
import json

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
        
        challengedata = json.dumps(
            {
                'base64Image': base64Image,
                'userLabel': userLabel,
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

        challengedata = json.dumps({ "$set" : { "completed" : 'True' } })
        r = requests.put(baseUrl + '/collections/challenges/' + challengeId + '?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP', data=challengedata, headers=headers)
        challenge = eval(r.text)

        userIdsToGivePoints = []
        r = requests.get(baseUrl + '/collections/users?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP')
        for t in eval(r.text):
            if t['username'] == username or t['username'] == challenge['fromUser']:
                userIdsToGivePoints.append({
                        'id': t['_id']['$oid'],
                        'score': int(t['score']) + int(challenge['points'])
                    })

        for user in userIdsToGivePoints:
            scoredata = json.dumps({ "$set" : { "score" : user['score'] } })
            r = requests.put(baseUrl + '/collections/users/' + user['id'] + '?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP', data=scoredata, headers=headers)

        return Response(str(r.text), mimetype='application/json')
