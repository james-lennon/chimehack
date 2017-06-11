import AVFoundation

func speakWord(){
	let synthesizer = AVSpeechSynthesizer()
	let utterance = AVSpeechUtterance(string: "Some text")
	utterance.rate = 0.2
	synthesizer.speak(utterance)
}
