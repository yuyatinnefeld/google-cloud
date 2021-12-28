from google.cloud import dataproc_v1 as dataproc


def create_cluster(*, project_id: str, region: str, cluster_name: str, config_bucket: str, temp_bucket: str) -> str:
    """Create a dataproc cluster """
    
    # Create a client with the endpoint set to the desired cluster region.
    cluster_client = dataproc.ClusterControllerClient(
        client_options={"api_endpoint": f"{region}-dataproc.googleapis.com:443"}
    )
    
    # Create the cluster config.
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
    
    # Create the cluster.
    operation = cluster_client.create_cluster(
        request={"project_id": project_id, "region": region, "cluster": cluster}
    )
    
    result = operation.result()

    clster_uuid = result.cluster_uuid
    
    # Output a success message.
    print(f"Cluster created successfully: {result.cluster_name}")
    
    return clster_uuid



def delete_cluster(*, project_id: str, region: str, cluster_name: str) -> None:
    """Delete the cluster."""
    cluster_client = dataproc.ClusterControllerClient(
        client_options={"api_endpoint": f"{region}-dataproc.googleapis.com:443"}
    )
    print("Tearing down cluster.")
    operation = cluster_client.delete_cluster(
        request={"project_id": project_id, "region": region, "cluster_name": cluster_name}
    )

def show_cluster_status(project_id: str, region: str, cluster_name: str) -> str:
    """Return the status of cluster"""
    
    cluster_client = dataproc.ClusterControllerClient(
        client_options={"api_endpoint": f"{region}-dataproc.googleapis.com:443"}
    )
    
    try:
        cluster = cluster_client.get_cluster(
            request={"project_id": project_id, "region": region, "cluster_name": cluster_name})
        return str(cluster.status.state.name)
    except Exception as e:
        print(e)
        return f"{cluster_name} doesn't exist"
