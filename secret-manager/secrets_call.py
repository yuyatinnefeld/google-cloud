from google.cloud import secretmanager


def access_secret_version(secret_id, version_id="latest"):
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/{project_id}/secrets/{secret_id}/versions/{version_id}"
    response = client.access_secret_version(name=name) 
    return response.payload.data.decode('UTF-8')


if __name__ == '__main__':
    project_id = "yt-demo-dev"
    secret_id = "PROJECT_ID"
    response = access_secret_version(secret_id)
    print(response)

    secret_id2 = "PROJECT_USER"
    response2 = access_secret_version(secret_id2)
    print(response2)
