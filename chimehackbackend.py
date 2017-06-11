from clarifai.rest import ClarifaiApp
from bs4 import BeautifulSoup
import requests
import resource
import ast

def getItem():
	app = ClarifaiApp("pqVhRqjUHu0x0ouWhuRnzTVR9ve1XyqiqQ0hbzal", "sHUtxZ7NRCSfz75EHbTy6Q9fk9-PGCwe3FKth2cV")
	model = app.models.get("general-v1.3")
	image = ClImage(file_obj=open('/home/user/image.jpeg', 'rb'))
	model.predict([image])
	#response = model.predict_by_url(url='https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/A_small_cup_of_coffee.JPG/275px-A_small_cup_of_coffee.JPG')

	objectname = response['outputs'][0]['data']['concepts'][0]['name']
	print objectname
	url = "http://sentence.yourdictionary.com/" + str(objectname)
	#url = "http://sentence.yourdictionary.com/apple"

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




