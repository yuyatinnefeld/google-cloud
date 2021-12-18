import yaml
import uuid


from typing import Tuple, Optional, Dict, Any
from google.cloud import dataproc_v1 as dataproc
from google.api_core.operation import Operation
from google.api_core.exceptions import AlreadyExists

from logger import logger


def read_yaml_config(path: str) -> Dict[str, Any]:
    """Read a YAML file and return a dictionary"""
    with open(path, "r") as f:
        try:
            config = yaml.safe_load(f)
        except yaml.YAMLError as exc:
            print(exc)
    return config


# Config setting up
# ============================================
config = read_yaml_config("resources/app_conf.yaml")

project_id = config['project_id']
region = config['region']
config_bucket = config['dataproc_staging_bucket']
temp_bucket = config['dataproc_temp_bucket']

DATAPROC_API_ENDPOINT=f"{region}-dataproc.googleapis.com:443"


def get_cluster(*, cluster_name: str) -> Optional[Operation]:
    """Return a dataproc cluster"""
    
    cluster_client = dataproc.ClusterControllerClient(client_options={"api_endpoint": f"{region}-dataproc.googleapis.com:443"})
    
    try:
        logger.info("cluster name: %s", cluster_name)
        operation = cluster_client.get_cluster(request={"project_id": project_id, "region": region, "cluster_name": cluster_name})
        return operation 
    except Exception as e:
        logger.error(f"cluster: {cluster_name} doesn't exist")
        return None


def create_cluster(*, cluster_name: str) -> Optional[Operation]:
    """Create a dataproc cluster """
    
    cluster_client = dataproc.ClusterControllerClient(client_options={"api_endpoint": DATAPROC_API_ENDPOINT})

    cluster = {
        "project_id": project_id,
        "cluster_name": cluster_name,
        "config": {
            "config_bucket": config_bucket,
            "temp_bucket": temp_bucket,
            "master_config": {"num_instances": 1, "machine_type_uri": "n1-standard-2"},
            "worker_config": {"num_instances": 2, "machine_type_uri": "n1-standard-2"},
        },
    }
    
    logger.info("cluster: %s is creating now", cluster_name)
    operation = cluster_client.create_cluster(request={"project_id": project_id, "region": region, "cluster": cluster})
    logger.info("cluster: %s is created successfully", cluster_name)
    return operation

def create_cluster_yaml_conf(*, path: str) -> Optional[Operation]:
    """Create a dataproc cluster with YAML config file"""
    try:
        cluster_config = read_yaml_config(path)
        logger.info("config yaml file is successfully read")
    except Exception as e:
        logger.waring("could not find a cluster config file", e)

    cluster_client = dataproc.ClusterControllerClient(client_options={"api_endpoint": DATAPROC_API_ENDPOINT})

    try:
        operation = cluster_client.create_cluster(
            request={
                "project_id": project_id, 
                "region": region, 
                "cluster": cluster_config
            })
    except AlreadyExists:
        operation = None
     
    return operation

def delete_cluster(*, cluster_name: str) -> Optional[Operation]:
    """Delete the cluster."""

    cluster_client = dataproc.ClusterControllerClient(client_options={"api_endpoint": DATAPROC_API_ENDPOINT})

    logger.info("cluster: %s is starting to tear down", cluster_name)
    operation = cluster_client.delete_cluster(request={"project_id": project_id, "region": region, "cluster_name": cluster_name})
    logger.info("cluster: %s is successfully deleted", cluster_name)
    return operation


def get_list_clusters():
    """List the details of clusters in the region."""

    cluster_client = dataproc.ClusterControllerClient(client_options={"api_endpoint": DATAPROC_API_ENDPOINT})
    cluster_list = cluster_client.list_clusters(request={"project_id": project_id, "region": region})
    return cluster_list
    

def start_workflow_template(template_name: str) -> Optional[Operation]:
    """
    Start a Dataproc job by using a Workflow Template

    Args:
        template_name: name of the dataproc workflow template
        parameters: parameters for the workflow template settings

    Returns:
        GCP API core operation
    """

    dataproc_workflow_client = dataproc.WorkflowTemplateServiceClient(client_options={"api_endpoint":DATAPROC_API_ENDPOINT})
    template_path = f"projects/{project_id}/regions/{region}/workflowTemplates/{template_name}"
    operation = dataproc_workflow_client.instantiate_workflow_template(name=template_path)

    return operation


def start_workflow_template_with_args(template_name: str, parameters: Dict[str, Any]) -> Optional[Operation]:
    """
    Start a Dataproc job by using a Workflow Template

    Args:
        template_name: name of the dataproc workflow template
        parameters: parameters for the workflow template settings

    Returns:
        GCP API core operation
    """    

    dataproc_workflow_client = dataproc.WorkflowTemplateServiceClient(client_options={"api_endpoint":DATAPROC_API_ENDPOINT})
    template_path = f"projects/{project_id}/regions/{region}/workflowTemplates/{template_name}"
    
    if parameters:
        operation = dataproc_workflow_client.instantiate_workflow_template(name=template_path, parameters=parameters)
    else:
        operation = dataproc_workflow_client.instantiate_workflow_template(name=template_path)

    logger.info("worflow-template: %s is successfully executed", template_name)

    #return operation

    return None




def submit_pyspark_job(*, cluster_name: str, job_name: str, main_python_file_uri: str, parameters: Dict[str, Any]) -> Optional[Operation]:
    """Submit Pyspark Job to use an existing dataproc cluster"""
    job_client = dataproc.JobControllerClient(client_options={"api_endpoint": DATAPROC_API_ENDPOINT})
    uuid_str = str(uuid.uuid4())
    job_name += uuid_str[:5]

    job_config = {
        "reference": {"job_id": job_name},
        "placement": {"cluster_name": cluster_name},
        "pyspark_job": {
            "main_python_file_uri": main_python_file_uri,
            "args": parameters,
        },
    }

    try:
        operation = job_client.submit_job_as_operation(
            request={
                "project_id": project_id, 
                "region": region,
                "job": job_config
            })

        job_uuid = operation.result().job_uuid
        logger.info("job: %s is successfully running", job_uuid)
    
    except AlreadyExists:
        operation = None

    return operation

