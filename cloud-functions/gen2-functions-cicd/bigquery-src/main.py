from datetime import date
import functions_framework
import os


@functions_framework.cloud_event
def bigquery_trigger_entry_point(cloudevent):
    table_name = os.environ['BQ_TABLE_ID']

    payload = cloudevent.data.get("protoPayload")

    try:
        bq_table = payload.get('resourceName')
        is_data_changed = payload.get('metadata').get('tableDataChange').get('reason')
        inserted_rowscount = payload.get('metadata').get('tableDataChange').get('insertedRowsCount')
    except:
        bq_table = None
        is_data_changed = None
    
    if table_name == bq_table and is_data_changed == 'QUERY' and inserted_rowscount == '2':
        print("payload: ",payload)
        print("⚡ bigquery table is updated ⚡")
        print(f"table: {table_name} is updated")
        print("🚀 some action 🚀")
        print("DONE!")