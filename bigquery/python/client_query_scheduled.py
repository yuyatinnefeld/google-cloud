from google.cloud import bigquery_datatransfer
from datetime import date

transfer_client = bigquery_datatransfer.DataTransferServiceClient()
today = date.today()
timestamp = today.strftime("%Y%m%d_%H%M%S")

def create_scheduled_query(project_id: str, dataset_id: str):
    service_account_name = "rw-yuyatinnefeld@yygcplearning.iam.gserviceaccount.com"

    # Use standard SQL syntax for the query.
    query_string = """
    SELECT
    CURRENT_TIMESTAMP() as current_time,
    @run_time as intended_run_time,
    @run_date as intended_run_date,
    17 as some_integer
    """

    parent = transfer_client.common_project_path(project_id)

    transfer_config = bigquery_datatransfer.TransferConfig(
        destination_dataset_id=dataset_id,
        display_name="YT Scheduled Query - Display Name",
        data_source_id="scheduled_query",
        params={
            "query": query_string,
            "destination_table_name_template": f"yt_table_{timestamp}",
            "write_disposition": "WRITE_TRUNCATE",
            "partitioning_field": "",
        },
        schedule="every 24 hours",
    )

    transfer_config = transfer_client.create_transfer_config(
        bigquery_datatransfer.CreateTransferConfigRequest(
            parent=parent,
            transfer_config=transfer_config,
            service_account_name=service_account_name,
        )
    )

    print("Created scheduled query '{}'".format(transfer_config.name))


def delete_scheduled_query(transfer_config_name: str):
    try:
        transfer_client.delete_transfer_config(name=transfer_config_name)
    except google.api_core.exceptions.NotFound:
        print("Transfer config not found.")
    else:
        print(f"Deleted transfer config: {transfer_config_name}")
