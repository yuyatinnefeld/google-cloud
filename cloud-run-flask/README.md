# Cloud Run

## Tech Stack
- Cloud Run (Serverless Docker Container)
- Flask (Application)
- Flask-RESTful (Extension for REST API)
- Dataproc (Data Engineering Core Function)
- Cloud Code (VS Code/Pycharm Extension for Deployment)


## About
This is a Dataproc Operator application and has the following functions
- list all dataproc clusters
- get a dataproc cluster
- create a dataproc cluster
- delete a dataproc cluster
- submit a dataproc job
- instantiate a dataproc workflow template

## Info: 
- https://cloud.google.com/run/docs/quickstarts/build-and-deploy/python
- https://cloud.google.com/code/docs/vscode/install
- https://flask-restful.readthedocs.io/en/latest/quickstart.html

1. create application files
- .dockerignore
- Dockerfile
- main.py
- requirements.txt

2. test
```bash
export FLASK_APP=main.py
flask run

# list all clusters
curl http://localhost:5000/cluster_list

# get a cluster
curl http://localhost:5000/cluster/cluster1
curl http://localhost:5000/cluster/cluster2

# add a cluster
curl http://localhost:5000/cluster_list -d "cluster_name=my_new_cluster_1" -X POST -v
curl http://localhost:5000/cluster_list -d "cluster_name=my_new_cluster_2" -X POST -v

# delete a cluster
curl http://localhost:5000/cluster/cluster2 -X DELETE -v
curl http://localhost:5000/cluster/cluster4 -X DELETE -v
```
3. install Cloud Code in VS Code

4. delete deploy not important files 
```bash
rm -rf venv
rm -rf __pycache__
```

5. run in the Cloud Code 
- Ctrl+Shift+P to show all commands 
- Cloud Code: Deploy to Cloud Run
- service name = dataproc-service
- Deployment Platform = Cloud Run (fully managed)
- region = europe-west1
- service account = dataproc cluster SA

6. test
```bash
SERVICE_NAME="data-proc-service-su5bcdndka-ew.a.run.app"
curl https://${SERVICE_NAME}/cluster_list
curl https://${SERVICE_NAME}/cluster_list -d "cluster_name=data_processing_cluster12345" -X POST -v
```