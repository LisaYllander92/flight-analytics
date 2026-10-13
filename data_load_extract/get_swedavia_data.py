import os
import requests
import json
import dlt
import pandas as pd
from dotenv import load_dotenv
from datetime import date
from datetime import timedelta
from datetime import datetime

load_dotenv()


# Get base url & API key from dotenv file
base_url = os.getenv("BASE_URL")
api_key = os.getenv("FLIGHT_KEY")

# Swedavia airport codes and names
SWE_AIRPORTS = {
    "ARN": "Stockholm Arlanda Airport",
    "BMA": "Bromma Stockholm Airport",
    "GOT": "Göteborg Landvetter Airport",
    "MMX": "Malmö Airport",
    "LLA": "Luleå Airport",
    "UME": "Umeå Airport",
    "OSD": "Åre Östersund Airport",
    "VBY": "Visby Airport",
    "RNB": "Ronneby Airport",
    "KRN": "Kiruna Airport",
}

# Dates [today, today -1, today-2]
DATES = [date.today(), date.today() - timedelta(days=1), date.today() -
         timedelta(days=2)]


# Flights data with response
def get_flight_data(url, params):
    # headers with api key
    headers = {
        "Ocp-Apim-Subscription-Key": api_key,
        "Accept": "application/json",
    }

    response = requests.get(url, header=headers, params=params)
    response.raise_for_status()  # check for http errors
    return json.loads(response.content.decode('utf8'))


# Resource for arrival/departure is created
# parameter : direction {arrivals/departures}
def make_flights_resource(direction):
    @dlt.resource(name=direction, write_disposition="replace")
    # resource for the flights arrival/departure
    def resource_flights(airports, dates):
        for airport in airports:
            for date in dates:
                url = f"{base_url}/{airport}/{direction}/{date}"
                flight_data = get_flight_data(url)

                for flight in flight_data.get("flights", []):
                    # swedavia airport code and name columns in raw data
                    flight["swedavia_airport_code"] = airport
                    flight["swedavia_airport_name"] = SWE_AIRPORTS[airport]
                    # The flight day we queried the API for (used for per-day analysis)
                    flight["query_date"] = date.isoformat()
                    # When this data was fetched (same for all rows in one run)
                    flight["data_fetched_date"] = datetime.now().isoformat()
                    yield flight


# # Source for flights (arrivals & departures)
# # This will be used in dagster later on
# @dlt.source
# def flights_source(airports, dates):
#     arrivals = make_flights_resource("arrivals")
#     departures = make_flights_resource("departures")
#     return arrivals(airports, dates), departures(airports, dates)
