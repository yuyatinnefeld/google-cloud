from google.cloud import bigquery


client = bigquery.Client()

def craete_dataset(dataset_name: str):
    dataset_id = "{0}.{1}".format(client.project, dataset_name)
    dataset = bigquery.Dataset(dataset_id)
    dataset.location = "europe-west3"
    dataset = client.create_dataset(dataset, timeout=30)
    print("Created dataset {}.{}".format(client.project, dataset.dataset_id))

def delete_dataset(dataset_name: str):
    dataset_id = "{0}.{1}".format(client.project, dataset_name)
    client.delete_dataset(
        dataset_id, delete_contents=True, not_found_ok=True
    )
