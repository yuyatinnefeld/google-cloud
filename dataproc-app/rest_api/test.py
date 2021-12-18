import gcp

#TODO: Integrate with API UI

template_name="yt-demo-dev-wf-temp4"

parameters = {
    "SOURCE_BUCKET": "data-validate-bucket",
    "SOURCE_FORMAT": "json",
    "DESTINATION": "bigquery",
    "DESTINATION_NAME": "dataset-validation-dataset",
    "OPT_PARAMS": "debugg=true model=RL x=200 y=100",
}

operation = gcp.start_workflow_template_with_args(template_name, parameters)
