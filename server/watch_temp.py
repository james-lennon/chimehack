import os
import time
from subprocess import Popen, PIPE

filename = "data/temp.jpg"
outfilename = "results.txt"

while True:
	last = os.stat(filename).st_mtime
	time.sleep(.2)
	if os.stat(filename).st_mtime != last:
		pipe = Popen(['darknet','detector','test','cfg/voc.data','cfg/tiny-yolo-voc.cfg','tiny-yolo-voc.weights','data/temp.jpg','-thresh','0.5'], stdout=PIPE)
        output = pipe.communicate()[0]

        correctLabels = ','.join([ line.split(':')[0] for line in output.split('\n')[1:] if len(line) > 0 ])

        with open(outfilename,'w') as f:
        	f.write(correctLabels)