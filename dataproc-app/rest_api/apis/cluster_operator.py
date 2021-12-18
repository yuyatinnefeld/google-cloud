from typing import Tuple, Optional

import gcp
from logger import logger


class ClusterOperator(object):
    def __init__(self):
        self.clusters = []


    def get(self, cluster_name:str) -> Optional[dict]:
        """Get an existing dataproc cluster object"""

        try:
            cluster = gcp.get_cluster(cluster_name=cluster_name)
            if cluster is not None:
                cluster_uuid = cluster.cluster_uuid
                cluster_status = cluster.status.state.name

                body = {
                    "cluster_name": cluster_name,
                    "cluster_uuid": cluster_uuid,
                    "status": cluster_status,
                }

            else:
                 body = {
                    "cluster_name": cluster_name,
                    "cluster_uuid": "not exist",
                    "status": "-",
                }               

            header = 200, body
            return header

        except Exception as e:
            logger.exception(e)
            return 404, None


    def get_list_clusters(self):
        """ Get all existing dataproc cluster"""

        cluster_list = gcp.get_list_clusters()
        self.clusters.clear()

        for cluster in cluster_list:
            logger.info("cluster: %s is listed", cluster.cluster_name)

            details = {
                "cluster_name": cluster.cluster_name,
                "cluster_uuid": cluster.cluster_uuid,
                "status": cluster.status.state.name,
            }
            
            self.clusters.append(details)

        header = 200, self.clusters
        return header


    def create(self, input_data:str) -> Optional[dict]:
        """Create a dataproc cluster object"""

        cluster = input_data
        logger.info("input data: %s", cluster)
        cluster_name = cluster['cluster_name']
        
        try:
            new_cluster = gcp.create_cluster(cluster_name=cluster_name).result()

            cluster_uuid = new_cluster.cluster_uuid
            logger.info("cluster uuid: %s", cluster_uuid)

            cluster_status = new_cluster.status.state.name
            logger.info("cluster uuid: %s", cluster_uuid)

            cluster['cluster_uuid'] = cluster_uuid
            cluster['status'] = cluster_status

            body = {
                "cluster_name": cluster_name,
                "cluster_uuid": cluster_uuid,
                "status": cluster_status,
            }

        except Exception as e:
            logger.exception(e)

            body = {
                "cluster_name": cluster_name,
                "cluster_uuid": "-",
                "status": "-",
            }

        header = 200, body
        return header


    def create_with_yaml(self) -> Optional[dict]:
        """Create a dataproc cluster object with a yaml file"""
                
        try:
            new_cluster = gcp.create_cluster_yaml_conf(path="resources/cluster_conf.yaml").result()
            cluster_name = new_cluster.cluster_name
            cluster_uuid = new_cluster.cluster_uuid
            cluster_status = new_cluster.status.state.name

            cluster['cluster_name'] = cluster_name
            cluster['cluster_uuid'] = cluster_uuid
            cluster['status'] = cluster_status

            body = {
                "cluster_name": cluster_name,
                "cluster_uuid": cluster_uuid,
                "status": cluster_status,
            }

        except Exception as e:
            logger.exception(e)

            body = {
                "cluster_name": "-",
                "cluster_uuid": "-",
                "status": "-",
            }

        header = 400, body
        return header


    def delete(self, cluster_name:str) -> None:
        """Delete a dataproc cluster instance
        Args:
            cluster_name(str): The name of cluster
        Returns:
            None
        """
        cluster = gcp.get_cluster(cluster_name=cluster_name)

        if cluster is not None:
            cluster_uuid = cluster.cluster_uuid
            cluster_status = cluster.status.state.name
            gcp.delete_cluster(cluster_name=cluster_name)
            body = {
                "cluster_name": cluster_name,
                "cluster_uuid": cluster_uuid,
                "status": cluster_status}
        else:
            body = {
                "cluster_name": cluster_name,
                "cluster_uuid": 'not exist',
                "status": '-'}     

        header = 200, body
        return header

    
    def submit_job(self, input_data:str):
        """Submit a dataproc job"""

        job_response = input_data
        logger.info("input data: %s", job_response)
        cluster_name = job_response['cluster_name']
        job_name = job_response['job_name']
        main_python_file_uri = job_response['main_python_file_uri']
        parameters = job_response['parameters']

        try:
            job_op = gcp.submit_pyspark_job(cluster_name=cluster_name, job_name=job_name, main_python_file_uri=main_python_file_uri, parameters=parameters)

            body = {
                "cluster_name": cluster_name,
                "job_name": job_name,
                "status": 'pyspark job started',
            }

        except Exception as e:
            logger.exception(e)

            body = {
                "cluster_name": cluster_name,
                "job_name": job_name,
                "status": "error",
            }

        header = 200, body
        return header