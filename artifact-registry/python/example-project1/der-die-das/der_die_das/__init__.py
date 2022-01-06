import sys

from bs4 import BeautifulSoup
import requests


def parser(class_element):
    class_element = str(class_element)
    s = str(class_element.split('<b><i>')[0])
    l = len(s)
    s = s[ l-4 : l-1]
    return s.upper()

def check(word):
    URL = f"https://www.verbformen.com/declension/nouns/{word}.htm"
    print(f"searched : {word}")
    site_request = requests.get(URL)
    
    if site_request.status_code:
        soup = BeautifulSoup(site_request.text, 'html.parser')
        class_element=soup.find_all(class_='vGrnd rCntr')
        artikel = parser(class_element)
        print(f"answer: {artikel} {word}")
    else:
        print("answer: NOT found")

if __name__ == '__main__':

    if len(sys.argv) != 2:
        print("Please put only ONE input word")
    else:
        input_word = sys.argv[1].capitalize()
        check(input_word)