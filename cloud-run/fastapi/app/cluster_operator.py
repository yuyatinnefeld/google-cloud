from typing import Dict, List

from app.gcp import get_list_clusters, create_cluster, get_cluster, delete_cluster
from app.logger import logger


class ClusterOperator(object):
    def __init__(self):
        self.cluster_list = []

    def get_list(self) -> List:
        """Get all existing dataproc cluster

        Returns:
            List: The cluster list
        """

        self.cluster_list.clear()
        clusters = get_list_clusters()

        for cluster in clusters:
            logger.info("cluster: %s is listed", cluster.cluster_name)

            details = {
                "cluster_name": cluster.cluster_name,
                "cluster_uuid": cluster.cluster_uuid,
                "status": cluster.status.state.name,
            }
            
            self.cluster_list.append(details)
                        
        return self.cluster_list
    
    def get_a_cluster(self, cluster_name:str) -> Dict:
        """Get an existing dataproc cluster object

        Args:
            cluster_name (str): The name of cluster

        Returns:
            Dict: API response
        """

        try:
            cluster = get_cluster(cluster_name=cluster_name)
            if cluster is not None:
                cluster_uuid = cluster.cluster_uuid
                cluster_status = cluster.status.state.name

                response = {
                    "cluster_name": cluster_name,
                    "cluster_uuid": cluster_uuid,
                    "status": cluster_status,
                }

            else:
                 response = {
                    "cluster_name": cluster_name,
                    "cluster_uuid": "not exist",
                    "status": "-",
                }         
                
            return response

        except Exception as e:
            logger.exception(e)
            return {"cluster_name": "no such cluster"}


    def create(self, cluster_name: str) -> Dict:
        """Create a dataproc cluster object

        Args:
            cluster_name (str): The name of cluster

        Returns:
            Dict: API response
        """

        try:
            new_cluster = create_cluster(cluster_name=cluster_name).result()

            cluster_uuid = new_cluster.cluster_uuid
            logger.info("cluster uuid: %s", cluster_uuid)

            cluster_status = new_cluster.status.state.name
            logger.info("cluster uuid: %s", cluster_uuid)

            response = {
                    "cluster_name": cluster_name,
                    "cluster_uuid": cluster_uuid,
                    "status": cluster_status,
            }

        except Exception as e:
            logger.exception(e)

            response = {
                    "cluster_name": cluster_name,
                    "cluster_uuid": "-",
                    "status": "-",
            }

        return response
    
    def delete(self, cluster_name:str) -> None:
        """Delete a dataproc cluster instance

        Args:
            cluster_name (str): The name of cluster

        Returns:
            Dict: API response
        """
        
        cluster = get_cluster(cluster_name=cluster_name)

        if cluster is not None:
            cluster_uuid = cluster.cluster_uuid
            cluster_status = cluster.status.state.name
            delete_cluster(cluster_name=cluster_name)
            response = {
                "cluster_name": cluster_name,
                "cluster_uuid": cluster_uuid,
                "status": cluster_status}
        else:
            response = {
                "cluster_name": cluster_name,
                "cluster_uuid": 'not exist',
                "status": '-'}     

        return response