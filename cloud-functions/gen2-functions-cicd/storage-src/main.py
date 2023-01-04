import os
import re
import functions_framework


@functions_framework.cloud_event
def gcs_trigger_entry_point(cloud_event):
    check_bucket_path = os.environ['BUCKET_PATH']

    data = cloud_event.data
    full_path = os.path.join(data["bucket"], data["name"])
    only_json = re.compile(r'.*json')
    only_specific_path = re.compile(check_bucket_path)

    print(f"A new input file was uploaded: {full_path}")
    
    if only_json.search(full_path) and only_specific_path.search(full_path):
        print(f"🎉 A new json file wad successfully uploaded in : {full_path} 🎉")
        print("do something!")