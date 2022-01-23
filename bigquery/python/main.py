from datetime import datetime
from pytz import timezone
from client_query_scheduled import *
from decouple import config
from client_dataset import *
from client_table import *
from client_interactive_query import *
from client_batch_query import *
from client_get_credentials import *
from client_list_jobs import list_jobs

project_id = config('PROJECT_ID')
project_id2 = config('PROJECT_ID2')
regional_location = config('REGIONAL_LOCATION')
multi_location = config('MULTI_LOCATION')
dataset_1 = config('DATASET_1')
dataset_2 = config('DATASET_2')
dataset_3 = config('DATASET_3')
table_1 = config('TABLE_1')
table_2 = config('TABLE_2')
credential_path = config('CREDENTIAL_PATH')

project_id = "yygcplearning"
project_id2 = ""
regional_location = ""
multi_location = ""
dataset_1 = ""
dataset_2 = ""
dataset_3 = ""
table_1 = ""
table_2 = ""

def get_cred(credential_path):
    credentials = get_credentials(credential_path)
    list_jobs(credentials, project_id, 10)
    return credentials

if __name__ == "__main__":
    print("main.py")
    get_cred(credential_path)

    #craete_dataset(data

    table_id1 = str("{0}.{1}.{2}").format(project_id, dataset_1, table_1)
    table_id2 = str("{0}.{1}.{2}").format(project_id, dataset_1, table_2)
    table_ids = [table_id1]

    #craete_dataset(dataset_3)
    #delete_dataset(dataset_3)
    #create_sample_table(dataset_2, table_1)
    #create_sample_clustering_table(dataset_2, table_2)
    #copy_table(table_ids, "project_id.dataset.tb1")
    #delete_table(table_id1)
    #delete_table(table_id2)

    col1, col2 = "date", "month"
    my_custom_small_table = str(
    """SELECT {0}, {1} FROM `{2}.{3}.{4}` LIMIT 100"""
    ).format(col1, col2, project_id, dataset_1, table_1)

    #job_id = interactive_query(my_custom_small_table)
    #batch_query(my_custom_small_table)    
    #job_status_print(job_id, "EU")

    #credentials = get_credentials(credential_path)
    #list_jobs(credentials, project_id, 10)()

    #create_scheduled_query(project_id2, dataset_1)
    
    ## Delete scheduled queries
    #check the transfer_config_name with the following cmd
    
    #bq ls \
    #--transfer_config \
    #--transfer_location=eu

    #tcn1="projects/928012749692/locations/europe/transferConfigs/6127a765-0000-25e1-9405-089e082fdc00"
    #tcn2="projects/928012749692/locations/europe/transferConfigs/6127b2f9-0000-2e9a-a324-30fd380f6764"
    #tcn3="projects/928012749692/locations/europe/transferConfigs/61421d92-0000-20fd-9a39-089e08213e78"
    #transfer_config_list = [tcn1, tcn2, tcn3]
    
    #for tcn in transfer_config_list:
    #    delete_scheduled_query(tcn)