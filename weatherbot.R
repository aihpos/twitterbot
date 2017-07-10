library(rvest)
library(magrittr)
library(ggplot2)
library(readr)
library(twitteR)

library(httr)
library(jsonlite)

#twitter api keys DO NOT CHANGE
consumer_key = "A7HPMfEZdy99Veym32LowWwhY"
consumer_secret = "K1TV83iwhMNqcVXedQj2COknRVtLpj75Z3yOEeayHhRf0aZy6b"
access_token = "883676781974310916-uIxWhKcdwJBnCvY9a7r8SMsfJY2bFYM"
access_secret = "zMnSDadMkCGozg7PCe4QLqtuV1mtD2wE1JCOqmLjTrzIY"
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

#darksky api stuff
darksky_url = "https://api.darksky.net/forecast/"
secret_key = "e3a621200d27236b437c65381f581d42"
location = "-90,0" #automatic location = south pole

#url for the query request
weather_url = sprintf("https://api.darksky.net/forecast/%s/%s", secret_key, location)

# converts into correct format
weatherinfo <- GET(weather_url)
#content(weatherinfo, as = "text")

#makes this shit usable
weatherinfo2 <- fromJSON(content(weatherinfo, as = "text"))
weatherinfo2

#formats text properly
temp_summary <- tolower(weatherinfo2$currently$summary)
temperature <- round(weatherinfo2$currently$temperature, digits = 2)
daily_summary <- tolower(weatherinfo2$hourly$summary)

#full string that we want to tweet
return_text = sprintf("It is currently %s and %g degrees F Will be %s", temp_summary, temperature, daily_summary)

#tweets the weather information for the south pole
tweet(return_text)








###########################################################################
#   OK so I wanted to try and have a function where users could tweet
#   at the bot with latitude + longitude coordinates (lat,lng format)
#   and the bot would reply with the current weather there.
#   So I took a google API that converts latitude + longitude into a
#   location name (i.e. 30.2672,-97.7431 is turned into "Austin, TX USA")
#   and then ran it back through the DarkSky weather API to get the weather
#   details in the same format as I did above.
#
#   All we need to do is figure out how to pull this information from a
#   retweet or a DM or a mention and store it in the correct variables.
###########################################################################



google_url <- "https://maps.googleapis.com/maps/api/geocode/json?latlng="
latlng <- "30.2672,-97.7431"
google_apikey <- "AIzaSyAjGD4iWBnYMqfiDt6Cf3RnPNBq-5IM8YA"
google_total <- sprintf("%s%s&key=%s", google_url, latlng, google_apikey)

#stores info
addressinfo <- GET(google_total)
addressinfo2 <- fromJSON(content(addressinfo, as = "text"))

#returns address of the location that user dm'ed
dm_address <- addressinfo2$results$formatted_address[5]

weather_url = sprintf("https://api.darksky.net/forecast/%s/%s", secret_key, latlng)

weatherinfo <- GET(weather_url)
#content(weatherinfo, as = "text")

#makes this shit usable
weatherinfo2 <- fromJSON(content(weatherinfo, as = "text"))
temp_summary <- tolower(weatherinfo2$currently$summary)
temperature <- round(weatherinfo2$currently$temperature, digits = 2)
daily_summary <- tolower(weatherinfo2$hourly$summary)

return_text = sprintf("It's currently %s and %g degrees F in %s", temp_summary, temperature, dm_address)
return_text

