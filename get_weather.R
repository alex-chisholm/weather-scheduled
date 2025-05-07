# Load necessary libraries
library(httr)
library(jsonlite)
library(dplyr)
library(readr)

# Set your API key (replace with your own)
api_key <- Sys.getenv("WEATHER_API_KEY")  # Insert your OpenWeatherMap API key here

# Define the endpoint for the weather data
url <- paste0("https://api.openweathermap.org/data/2.5/weather?q=Amsterdam,nl&appid=", api_key, "&units=metric")

# Make the API request
response <- GET(url)
weather_data <- fromJSON(content(response, "text"))

weather_df <- data.frame(
  city = weather_data$name,
  country = weather_data$sys$country,
  date = format(as.POSIXct(weather_data$dt, origin = "1970-01-01", tz = Sys.timezone()), "%Y-%m-%d %H:%M:%S %Z"),
  temp_c_current = weather_data$main$temp,
  temp_c_min = weather_data$main$temp_min,
  temp_c_max = weather_data$main$temp_max,
  pressure = weather_data$main$pressure,
  humidity = weather_data$main$humidity,
  wind_speed = weather_data$wind$speed,
  description = weather_data$weather$description,
  stringsAsFactors = FALSE
)

write_csv(weather_df, "weather.csv")
