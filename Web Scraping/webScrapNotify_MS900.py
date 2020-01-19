'''
==========================================================================================================
Author                  : Joe Richards
Created Date            : 19/01/2020
Python Version          : 3
Description             : Simple web scrapping to get MS900 book details from Microsofts website.
                          URL: https://www.microsoftpressstore.com/store/exam-ref-ms-900-microsoft-365-fundamentals-9780136484875
                          Wb scraps the following:
                                Title.
                                Author.
                                Release date.

Version                 : 1.0
Link                    : https://github.com/joer89/Fun.git

'''

import requests
from bs4 import BeautifulSoup
import re
import datetime

#Requests the website we are looking at.
url ="https://www.microsoftpressstore.com/store/exam-ref-ms-900-microsoft-365-fundamentals-9780136484875"
page = requests.get(url

#Gets the html content.
soup = BeautifulSoup(page.content, 'html.parser')
print("\nBook Details.\n\nTitle: {}".format(soup.find(id="storeProductTitle").get_text()))

#gets the first list element (displays the author.)
author = soup.find(class_="product-sub-info").find("ul")
print("Author: {}".format(author.findChildren()[0].get_text()))

#Gets the first list element (displays the release date(is american date order)).
releaseDate = soup.find(class_="row bss-bib").find("ul")
release = releaseDate.findChildren()[0].get_text()

#Get the date of release in a string with regex.
releaseDateReg = re.search("[\d+]/[\d+]/[\d]+", str(releaseDate))
releaseDateRegex  = releaseDateReg.group()
print("Release date: {}\n".format(releaseDateRegex))

#get todays date andp put it in american order.
todayYear = datetime.date.today().year
todayMonth = datetime.date.today().month
todayDay = datetime.date.today().day
americanDate = ("{}/{}/{}".format(todayMonth, todayDay, todayYear))

#Print out on screen the result.
if(releaseDateRegex  > americanDate):
    print("Not yet released, todays date is " + americanDate + ", release date is " + releaseDateRegex)
elif(releaseDateRegex < americanDate):
    print("Is available, todays date is " + americanDate + ", release date is " + releaseDateRegex)
elif(releaseDateRegex == americanDate):
    print("Is out today!! Todays date is " + americanDate + ", release date is " + releaseDateRegex)
