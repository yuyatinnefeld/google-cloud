from google.cloud import bigquery


def client_query_dry_run():
    client = bigquery.Client()

    job_config = bigquery.QueryJobConfig(dry_run=True, use_query_cache=False)

    query_job = client.query(
        (
            "SELECT name, COUNT(*) as name_count "
            "FROM `bigquery-public-data.usa_names.usa_1910_2013` "
            "WHERE state = 'WA' "
            "GROUP BY name"
        ),
        job_config=job_config,
    )

    print("This query will process {} bytes.".format(query_job.total_bytes_processed))
    return query_job