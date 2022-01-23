from google.cloud import bigquery
import datetime

def set_my_query():
    my_query = 'SELECT * FROM ds_eu.covid LIMIT 10'
    return my_query

def create_client():
    client = bigquery.Client()
    return client

def get_query_job(client, my_query):
    query_job = client.query(
            my_query,
            job_config=bigquery.QueryJobConfig(
                labels={"job-type": "analyze"}, maximum_bytes_billed=100000000
            ),
            job_id_prefix="datascience_job_123_",
    )
    return query_job

def print_result(query_job):
    print("The query data:")
    rows = query_job.result()
    for idx, row in enumerate(rows):
        print(f"{idx}: {row} \n")

if __name__ == "__main__":
    my_query = set_my_query()
    client = create_client()
    query_job = get_query_job(client, my_query)
    print_result(query_job)