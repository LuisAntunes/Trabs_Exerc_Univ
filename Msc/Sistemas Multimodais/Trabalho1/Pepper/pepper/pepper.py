import logging
import speech_recognition as sr
import os
import sys
import time
import webbrowser
import wolframalpha
import sys
from gtts import gTTS

logger = logging.getLogger(__name__)

# wolframalpha API key
app_id='EETRLL-7A9JE72P53'

class Pepper(object):

    # Built-in words

    PEPPER_NAMES = ["peppa", "pepa", "pepper", "peper", "pepar", "peppar"]

    PEPPER_TIME_COMMANDS = ["what's the time", "what time is it",
                            "tell me the time", "report the time","time please",
                            "what day is it", "which day is today", "what day's it"
                            "report what day is it"]

    PEPPER_GREETING = ["hello", "hi", "greetings"]

    PEPPER_OPEN_ACTIONS = ["browser", "map", "maps", "gmail", "g mail",
                           "google mail", "facebook", "face book", "you tube",
                           "youtube"]

    STOP_LISTENING = ["go away", "stop listening", "shut down",
                               "shat dawn", "shut dawn", "shat down", "that is all"
                               "that's all", "shutdown"]

    SWEAR = ["say a swear word", "swear for me", "please swear",
             "please say a swear word", "please swear for me"]



    @classmethod
    def speak(self, text):
        """
        Processes the text and reproduces it (TTS method)
        """

        tts = gTTS(text=(text), lang='en')
        tts.save("speech.mp3")
        os.system("mpg321 speech.mp3 -quiet")

    @classmethod
    def handle_wolframalpha_search(self, query):
        client = wolframalpha.Client(app_id)
        res = client.query(query)

        if len(res.pods) > 0:
            string = ""
            pod = res.pods[1]
            if pod.text:
                string = pod.text
            else:
                self.speak("I'm sorry boss, but I'm unable to find a response.")

            string = string.encode('ascii', 'ignore')
            self.speak("The result is: " + string)
            logger.debug("The result is: "+ string)
        else:
            self.speak("I'm sorry boss, but I'm not sure about the answer.")

    @classmethod
    def handle_action(self, text, **kwargs):
        """
        Action handler. Handles a text command accordingly.
        """

        # Use lowercase for processing.
        text = text.lower()

        logger.debug("Received text: '%s'", text)

        if any(word in text for word in self.STOP_LISTENING):
            self.speak("As you wish boss. Enjoy your day.")
            sys.exit()
        elif any(word == text for word in self.PEPPER_NAMES):
            self.speak("Yes boss?")
        elif "how are you" in text:
            self.speak("I'm fine, thank you.")
        elif "thank you" in text:
            self.speak("Any time boss.")
        elif any("day" in text for word in self.PEPPER_TIME_COMMANDS):
            self.speak(time.strftime("%x"))
        elif any(word in text for word in self.PEPPER_TIME_COMMANDS):
            self.speak(time.strftime("%X"))
        elif any(word in text for word in self.PEPPER_GREETING):
            self.speak("Hello boss.")
        elif any(string == text for string in self.SWEAR):
            self.speak("I'm sorry boss, but I was not built to execute such a task.")
        elif "open" in text:
            obj = text.split("open ")[1]

            if obj not in self.PEPPER_OPEN_ACTIONS:
                self.speak("I'm sorry boss, but I'm unable to recognize the open command")
            else:
                if "browser" in obj:
                    self.speak("Opening browser.")
                    webbrowser.open("https://www.google.com/")
                elif "map" in obj:
                    self.speak("Opening maps.")
                    webbrowser.open("https://www.google.com/maps/")
                elif "gmail" in obj:
                    self.speak("Opening gmail.")
                    webbrowser.open("https://mail.google.com/")
                elif "facebook" in obj:
                    self.speak("Opening facebook.")
                    webbrowser.open("https://www.facebook.com/")
                elif "youtube" in obj:
                    self.speak("Opening youtube.")
                    webbrowser.open("https://www.youtube.com/")
        elif "search" in text:
            self.speak("Opening google search.")
            url = "https://www.google.com.tr/search?q={}".format(text.split("search ")[1])
            webbrowser.open(url)
        elif "calculate" in text:
            self.handle_wolframalpha_search(text.split("calculate ")[1])




    @classmethod
    def initiate_Pepper(self):
        """
        Initializes Pepper and starts the listening loop
        """

        self.speak('Greetings. My name is Pepper. How could I be of service?')

        # starts the recognizer
        r = sr.Recognizer()

        with sr.Microphone() as source:

            while True:
                logger.debug("Awaiting user input.")
                audio = r.listen(source)

                logger.debug("Interpreting user input.")

                # Speech recognition using Google Speech Recognition
                try:
                    result = r.recognize_google(audio)
                    #result = r.recognize_sphinx(audio)

                    self.handle_action(result)

                except sr.UnknownValueError:
                    logger.debug("Could not understand audio")
                    #Pepper.speak("I'm sorry, but I couldn't understand what you said.")
                except sr.RequestError as e:
                    logger.warn("Could not request results from Google Speech Recognition service: %s", e)
                except Exception as e:
                    logger.error("Could not process text: %s", e)
