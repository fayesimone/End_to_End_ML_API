# FastAPI Machine Learning Applications

The AKS resources support two FastAPI machine learning applications: a support vector regression model to predict median housing values for districts in California (lab4) and a pre-trained transformer model from HuggingFace for natural language sentiment analysis (project). Redis is leveraged for caching the model data based on input from the client. 

The lab4 application has two endpoints: /bulkpredict and /predict. The /bulkpredict and /predict endpoint ingests and validates feature variable values supplied by the client and checks the data input against the redis cache. If the data key is present in the cache, the api endpoint supplies the data value to the client. Otherwise, the api endpoint supplies the data to the ML model, reports the prediction back to the client, and sends the data to be cached in redis. The /bulkpredict endpoint can handle multiple inputs in the form of a list, while the /predict endpoint can only handle a single input.

The project application has one /bulk-predict endpoint that ingests and validates feature variable values supplied by the client and checks the data input against the redis cache. If the data key is present in the cache, the api endpoint supplies the data value to the client. Otherwise, the api endpoint supplies the data to the ML model, reports the prediction back to the client, and sends the data to be cached in redis. The /bulkpredict endpoint can handle multiple inputs in the form of a list of strings.

## Build Application & Deploy on AKS

From the command line run the deploy-aks.sh bash script.

```bash
bash /home/ftitchenal/DATASCI_255/lab4-azure-kubernetes-fayesimone/lab4/deploy-aks.sh

bash /home/ftitchenal/DATASCI_255/project-pytorch-fastapi-fayesimone/deploy-aks.sh
```

From the command line, hit the prediction endpoints using the following curl commands. 

```bash
curl -X 'POST' \
    'https://fayetitchenal.mids255.com/lab4/predict' \
    -L -H 'Content-Type: application/json' \
    -d '{"MedInc": 1, "HouseAge": 1, "AveRooms": 1, "AveBedrms": 1, "Population": 1, "AveOccup": 1, "Latitude": 1, "Longitude": 1}'

curl -X 'POST' \
 'https://fayetitchenal.mids255.com/lab4/bulk-predict' \
  -L -H 'Content-Type: application/json' \
  -d '{"houses": [{ "MedInc": 8.3252, "HouseAge": 42, "AveRooms": 6.98, "AveBedrms": 1.02, "Population": 322, "AveOccup": 2.55, "Latitude": 37.88, "Longitude": -122.23 }, { "MedInc": 9, "HouseAge": 10, "AveRooms": 11, "AveBedrms": 12, "Population": 13, "AveOccup": 14, "Latitude": 15, "Longitude": 16 }]}'

curl -X 'POST' \
 'https://fayetitchenal.mids255.com/project/bulk-predict' \
 -H 'accept: application/json' \
 -H 'Content-Type: application/json' \
 -d '{ "text": [
"I hate you.", "I love you."
 ]
}'
```

## Testing Performance of Project Application

During peak load testing, the application was able to respond to requests within 1 second for 99% of requests. There were two spikes in P99 latency, each hitting about 3 seconds response time. These spikes are likely correlated when resources were coming online as part of horizontal pod autoscaling. 
![Requests duration during load testing.](/mlapi/request_dur_project.png)Figure 1


Despite these two peaks in P99 response time latency, all requests had good responses (200). 
![Request response codes during load testing.](/mlapi/requests_responsecodes_project.png)Figure 2