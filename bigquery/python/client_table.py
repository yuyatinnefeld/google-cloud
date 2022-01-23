from google.cloud import bigquery


client = bigquery.Client()

def create_sample_table(dataset_name: str, table_name: str):
    table_id = "{0}.{1}.{2}".format(client.project, dataset_name, table_name)

    field1_name = "full_name"
    field1_type = "STRING"
    field2_name = "age"
    field2_type = "INTEGER"
    field3_name = "date"
    field3_type = "DATE"

    schema = [
        bigquery.SchemaField(field1_name, field1_type, mode="REQUIRED"),
        bigquery.SchemaField(field2_name, field2_type),
        bigquery.SchemaField(field3_name, field3_type, mode="REQUIRED"),
    ]

    table = bigquery.Table(table_id, schema=schema)
    table = client.create_table(table)  # Make an API request.

    print(
        "Created table {}.{}.{}".format(table.project, table.dataset_id, table.table_id)
    )

def create_sample_clustering_table(dataset_name: str, table_name: str):
    table_id = "{0}.{1}.{2}".format(client.project, dataset_name, table_name)

    job_config = bigquery.LoadJobConfig(
        skip_leading_rows=1,
        source_format=bigquery.SourceFormat.CSV,
        schema=[
            bigquery.SchemaField("timestamp", bigquery.SqlTypeNames.TIMESTAMP),
            bigquery.SchemaField("origin", bigquery.SqlTypeNames.STRING),
            bigquery.SchemaField("destination", bigquery.SqlTypeNames.STRING),
            bigquery.SchemaField("amount", bigquery.SqlTypeNames.NUMERIC),
        ],
        time_partitioning=bigquery.TimePartitioning(field="timestamp"),
        clustering_fields=["origin", "destination"],
    )

    job = client.load_table_from_uri(
        ["gs://cloud-samples-data/bigquery/sample-transactions/transactions.csv"],
        table_id,
        job_config=job_config,
    )

    job.result()  # Waits for the job to complete.

    table = client.get_table(table_id)  # Make an API request.
    print(
        "Loaded {} rows and {} columns to {}".format(
            table.num_rows, len(table.schema), table_id
        )
    )

def copy_table(table_ids: str, new_table_id: str):
    job = client.copy_table(table_ids, new_table_id)
    job.result()
    print("The tables {} have been appended to {}".format(table_ids, new_table_id))


def delete_table(table_id: str):
    client.delete_table(table_id, not_found_ok=True)
    print("Deleted table '{}'.".format(table_id))