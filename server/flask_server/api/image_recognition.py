from flask import url_for
from bs4 import BeautifulSoup
from clarifai import rest
from clarifai.rest import ClarifaiApp
from clarifai.rest import Image as ClImage
from os.path import dirname, join
import requests
import resource
import ast
import json
import base64
import urllib
import os


class ImageRecognizer(object):
    
    def getImageRecognition(self, image_url, target_language, isBase64=False):
        """
        Return a tuple containing the term, example, translations, and gif

        params: image_url (string)
        returns: image_name, sentence_example, giphy_example (tuple)
        """
        clarifai_app = ClarifaiApp("pqVhRqjUHu0x0ouWhuRnzTVR9ve1XyqiqQ0hbzal", "sHUtxZ7NRCSfz75EHbTy6Q9fk9-PGCwe3FKth2cV")
        model = clarifai_app.models.get("general-v1.3")

        if isBase64:
            image = app.inputs.create_image_from_base64(image_url)
        else:
            image = ClImage(url=image_url)

        response = model.predict([image])

        image_name = response['outputs'][0]['data']['concepts'][0]['name']
        t_image_name = self.getTranslatedImageName(image_name, target_language)
        sentence_example = self.getSentenceExampleFromImageName(image_name)
        t_sentence_example = self.getTranslatedSentenceExample(sentence_example, target_language)
        giphy_example = self.getGiphy(image_name)
        return (image_name, t_image_name, sentence_example, t_sentence_example, giphy_example)

    def getSentenceExampleFromImageName(self, image_name):
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

    def getTranslatedImageName(self, image_name, target_language):
        """
        Return the giphy URL (ending in .gif)

        params: image_name (string)
        returns: giphy (string)
        """
        url = self.generateTranslationURL(image_name, target_language)
        r = requests.get(url)
        r_dict = json.loads(r.text)
        return r_dict['data']['translations'][0]['translatedText']

    def getTranslatedSentenceExample(self, sentence_example, target_language):
        """
        Return the giphy URL (ending in .gif)

        params: image_name (string)
        returns: giphy (string)
        """
        url = self.generateTranslationURL(sentence_example, target_language)
        r = requests.get(url)
        r_dict = json.loads(r.text)
        return r_dict['data']['translations'][0]['translatedText']

    def generateTranslationURL(self, query, target_language):
        """
        Return the giphy URL (ending in .gif)

        params: image_name (string)
        returns: giphy (string)
        """
        url1 = "https://translation.googleapis.com/language/translate/v2?target="
        url2 = "&q="
        url3 = "&key=AIzaSyDGbE9rp2PdnWMG910ccLlPWo6eOi_Gu4c"
        return url1 + target_language + url2 + query + url3

    def getGiphy(self, image_name):
        """
        Return the giphy URL (ending in .gif)

        params: image_name (string)
        returns: giphy (string)
        """
        url = "http://api.giphy.com/v1/gifs/search?q=" + str(image_name) + "&api_key=dc6zaTOxFJmzC"
        r = requests.get(url)
        r_dict = json.loads(r.text)
        gif = r_dict['data'][4]['images']['original']['url']
        urllib.urlretrieve(gif, join(join(dirname(os.getcwd()), "server/flask_server/static"), "saved_gif.gif"))
        return url_for('static', filename='saved_gif.gif')