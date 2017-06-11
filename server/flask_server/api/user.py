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

class UserEndpoint(Resource):
    def post(self):
        """
        REST: GET (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        username = request.values.get('username', None)
        
        r = requests.get(baseUrl + '/collections/users?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP')
        for t in eval(r.text):
            if username == t['username']:
                return Response('{"err":"username already exists"}', mimetype='application/json')

        userdata = json.dumps(
            {
                'username': username,
                'score': 0
            }
        )
        r = requests.post(baseUrl + '/collections/users?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP', data=userdata, headers=headers)

        return Response(str(r.text), mimetype='application/json')

    def get(self):
        """
        REST: GET (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        
        r = requests.get(baseUrl + '/collections/users?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP')
        users = [ t['username'] for t in eval(r.text) ]
        return Response(json.dumps({'users':users}), mimetype='application/json')

    def put(self):
        """
        REST: GET (parse the request for message parameters and returns proper response)

        params: Request (Object)
        returns: Response (Object)
        """
        score = request.values.get('score', None)
        username = request.values.get('username', None)
        r = requests.get(baseUrl + '/collections/users?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP')
        for t in eval(r.text):
            if username == t['username']:
                userId = t['_id']['$oid']
                scoredata = json.dumps({ "$set" : { "score" : score } })
                r = requests.put(baseUrl + '/collections/users/' + userId + '?apiKey=rIq_Ya-BmzlQouKMBnmt1CLINnw-riZP', data=scoredata, headers=headers)

                return Response(str(r.text), mimetype='application/json')

        return Response('{"err":"username does not exist"}', mimetype='application/json')
