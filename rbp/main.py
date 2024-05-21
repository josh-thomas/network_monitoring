# import requests
import time
import threading
import os
import httpx
from prometheus_client import start_http_server, Gauge

CLIENT_PORT = 8080
WEBSITE_FILE = 'websites.txt'

# name of the RP which should include the location info of the RP
rp_name = os.getenv('RP_name')
print(f"RP name: {rp_name}")
def run_latency_metric(urls):
    def _measure_latency(url):
        # measure latency for a get request to a url
        try:
            client = httpx.Client(http2=True, follow_redirects=True)
            start_time = time.time()
            response = client.get(url)
            end_time = time.time()
            if response.status_code == 200:
                latency = end_time - start_time
                return latency
            else:
                print(f"Error: {url} returned {response.status_code}")
                return None
        except Exception as e:
            print(f"Error: {e}")
            return None

    latency_metric = Gauge('latency', 'latency of GET requests to a url', ['url', 'RP_name'])
    while True:
        for url in urls:
            latency = _measure_latency(url)
            if latency is not None:
                latency_metric.labels(url=url, RP_name=rp_name).set(latency)
                print(f"{url}: {latency}")

def run_isAlive_metric():
    isAlive_metric = Gauge('isAlive', 'status of RP. 1 means alive. 0 means the RP is down', ['RP_name'])
    while True:
        isAlive_metric.labels(RP_name=rp_name).set(1)

def main():
    def _get_url_list(file_path):
        # read in list of websites from text file
        try:
            with open(file_path, 'r') as file:
                lines = file.read().splitlines()
            return lines
        except FileNotFoundError:
            print(f"Error: File '{file_path}' not found.")
            return None
        except Exception as e:
            print(f"An error occurred: {e}")
            return None
    urls = _get_url_list(WEBSITE_FILE)
    start_http_server(CLIENT_PORT)
    threads = []

    # latency metric thread
    latency_metric_thread = threading.Thread(target=run_latency_metric, args=([urls]))
    latency_metric_thread.start()
    isAlive_metric_thread = threading.Thread(target=run_isAlive_metric)
    isAlive_metric_thread.start()
    threads.append(isAlive_metric_thread)
    threads.append(latency_metric_thread)

    # add more metrics as needed

    for thread in threads:
        thread.join()
    return

if __name__ == "__main__":
    main()