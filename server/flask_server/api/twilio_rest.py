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
import os
import json
import random

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
        dir_path = os.path.dirname(os.path.realpath(__file__))
        with open(os.path.join(dir_path, 'hack_codes.json')) as data_file:
            hack_codes = json.load(data_file)

        num_media = int(request.values.get('NumMedia'))

        print(hack_codes)

        if (num_media == 1):
            image_url = request.values.get('MediaUrl0', None)
            image_recognition = image_recognizer.getImageRecognition(image_url, hack_codes['SOURCE_LANGUAGE'], hack_codes['TARGET_LANGUAGE'])
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
        else:
            message_body = request.values.get('Body', None)
            language_response = getLanguage(message_body)
            response_type = None

            if 'can speak' in message_body or 'know' in message_body:
                response_type = 'source'

            elif 'want' in message_body or 'learn' in message_body:
                response_type = 'target'

            ####################
            # LANGUAGE SETTING #
            ####################

            if language_response != False:
                if response_type == 'source':
                    full_language, source_language = language_response
                    hack_codes['SOURCE_LANGUAGE'] = source_language
                    hack_codes['activated_index'] = 0

                    print(hack_codes)
                    dir_path = os.path.dirname(os.path.realpath(__file__))
                    with open(os.path.join(dir_path, 'hack_codes.json'), 'w') as outfile:
                        json.dump(hack_codes, outfile)

                    resp = MessagingResponse()
                    resp.append(Message().body("Got it! We now know you can speak " + full_language))
                    return Response(str(resp), mimetype='application/xml')

                if response_type == 'target':
                    full_language, target_language = language_response
                    hack_codes['TARGET_LANGUAGE'] = target_language
                    hack_codes['activated_index'] = 0

                    print(hack_codes)
                    dir_path = os.path.dirname(os.path.realpath(__file__))
                    with open(os.path.join(dir_path, 'hack_codes.json'), 'w') as outfile:
                        json.dump(hack_codes, outfile)

                    resp = MessagingResponse()
                    resp.append(Message().body("Success! We changed your language setting to learn " + full_language))
                    return Response(str(resp), mimetype='application/xml')

            ###########################
            # SETTING SOURCE LANGUAGE #
            ###########################

            elif language_response == False and hack_codes['activated_index'] == 0:
                hack_codes['activated_index'] = 1
                dir_path = os.path.dirname(os.path.realpath(__file__))
                with open(os.path.join(dir_path, 'hack_codes.json'), 'w') as outfile:
                    json.dump(hack_codes, outfile)

                resp = MessagingResponse()
                resp.append(Message().body("Hi there. What language can you speak?"))
                return Response(str(resp), mimetype='application/xml')

            ###########################
            # SETTING TARGET LANGUAGE #
            ###########################

            elif language_response == False and hack_codes['activated_index'] == 1:
                hack_codes['activated_index'] = 2
                dir_path = os.path.dirname(os.path.realpath(__file__))
                with open(os.path.join(dir_path, 'hack_codes.json'), 'w') as outfile:
                    json.dump(hack_codes, outfile)

                resp = MessagingResponse()
                resp.append(Message().body("And want language do you want to learn?"))
                return Response(str(resp), mimetype='application/xml')

            ######################
            # FAILING GRACEFULLY #
            ######################

            else:
                potential_responses = [
                    "Sorry! We couldn't understand that on our end. Maybe someone hacked the freedom tower.",
                    "Dang.. our system couldn't parse your message. Please try again.",
                    "We got a response of not hotdog... that can't be right. Can you try again?",
                    "We couldn't understand your message, could you try again?",
                    "We didn't catch that. Could you try rephrasing your message?"
                ]
                resp = MessagingResponse()
                resp.append(Message().body(random.choice(potential_responses)))
                return Response(str(resp), mimetype='application/xml')

def getLanguage(message_body):
    """
    Return target language given the message body.

    params: Request (Object)
    returns: Response (Object)
    """
    message_body_parts = message_body.split()
    target_language = message_body_parts[-1].lower()

    dir_path = os.path.dirname(os.path.realpath(__file__))
    with open(os.path.join(dir_path, 'language_codes.json')) as data_file:
        language_codes = json.load(data_file)
    
    result = False
    lower_language_codes = {k.lower(): v for k, v in language_codes.items()}
    for k, v in lower_language_codes.items():
        if k.startswith(target_language):
            result = (k, v)
            return result

    if result == False:
        for k, v in language_codes.items():
            if k in message_body:
                result = (k, v)
                return result
    
    return result

