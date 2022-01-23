from google_auth_oauthlib import flow

def get_credentials(credential_path):
    launch_browser = True

    appflow = flow.InstalledAppFlow.from_client_secrets_file(
        credential_path, scopes=["https://www.googleapis.com/auth/bigquery"]
    )

    if launch_browser:
        appflow.run_local_server()
    else:
        appflow.run_console()

    credentials = appflow.credentials

    return credentials