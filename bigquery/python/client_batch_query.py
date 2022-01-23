from google.cloud import bigquery


client = bigquery.Client()

def batch_query(my_query: str):
    
    job_config = bigquery.QueryJobConfig(
        priority=bigquery.QueryPriority.BATCH
    )

    query_job = client.query(my_query, job_config=job_config)

    query_job = client.get_job(
        query_job.job_id, location=query_job.location
    )

    print("Job {} is currently in state {}".format(query_job.job_id, query_job.state))