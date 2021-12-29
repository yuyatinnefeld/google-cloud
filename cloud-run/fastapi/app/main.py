from typing import List, Optional
from enum import Enum

from fastapi import FastAPI

from app.logger import logger
from app.cluster_operator import ClusterOperator
from app.wf_temp_operator import WorkflowTemplateOperator

ClusterOperator = ClusterOperator()
WorkflowTemplateOperator = WorkflowTemplateOperator()

class WorkflowTemplates(str, Enum):
    wf_temp1 = "data-collection-workflow-temp"
    wf_temp2 = "data-processing-workflow-temp"
    wf_temp3 = "data-validation-workflow-temp"
    wf_temp4 = "yt-demo-dev-wf-temp1"

app = FastAPI()

@app.get("/")
def read_root():
    return {"Dataproc": "API"}

@app.get("/clusters/")
async def get_cluster_list():
    cluster_items = ClusterOperator.get_list()
    return cluster_items

@app.get("/clusters/get/{cluster_name}")
async def get_cluster(cluster_name: str):
    return ClusterOperator.get_a_cluster(cluster_name)

@app.post("/clusters/create/{cluster_name}")
async def create_cluster(cluster_name: str):
    new_cluster = ClusterOperator.create(cluster_name)
    return new_cluster

@app.delete("/clusters/delete/{cluster_name}")
async def delete_cluster(cluster_name: str):
    deleted_cluster = ClusterOperator.delete(cluster_name)
    return deleted_cluster
    
@app.get("/workflow-temp/{wf_temp_name}")
async def run_workflow_template(wf_temp_name: WorkflowTemplates):
    if(
        #wf_temp_name.value == "data-collection-workflow-temp" or 
        #wf_temp_name.value == "data-processing-workflow-temp" or
        #wf_temp_name.value == "data-validation-workflow-temp" or
        wf_temp_name.value == "yt-demo-dev-wf-temp1"

    ):
        WorkflowTemplateOperator.start(wf_temp_name)
        return {"wf_temp_name": wf_temp_name, "job": f"starting..."}
    else:
        return {"wf_temp_name": "use a defined template", "job": " - "}

