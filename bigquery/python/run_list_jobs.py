from client_get_credentials import get_credentials
from client_list_jobs import list_jobs
from decouple import config


credential_path = config('CREDENTIAL_PATH')
project_id2 = config('PROJECT_ID2')

if __name__ == "__main__":
    project_id2
    job_results_count=20
    credentials = get_credentials(credential_path)
    list_jobs(credentials, project_id2, job_results_count)