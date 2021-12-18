#global env variables
PROJECT_ID=$(gcloud config get-value project)
REGION=europe-west1

SCALING_POLICY_SOURCE=./resources/autoscaling_policy.yaml
POLICY_ID=${PROJECT_ID}-autoscaling-policy

TEMPLATE_1_ID=${PROJECT_ID}-wf-temp1
TEMPLATE_2_ID=${PROJECT_ID}-wf-temp2
TEMPLATE_3_ID=${PROJECT_ID}-wf-temp3
TEMPLATE_4_ID=${PROJECT_ID}-wf-temp4
TEMPLATE_5_ID=${PROJECT_ID}-wf-temp5

WT_TEMP_1_SOURCE=./resources/wf_temp_1.yaml
WT_TEMP_2_SOURCE=./resources/wf_temp_2.yaml
WT_TEMP_3_SOURCE=./resources/wf_temp_3.yaml
WF_TEMP_4_SOURCE=./resources/wf_temp_4.yaml
WF_TEMP_5_SOURCE=./resources/wf_temp_5.yaml

### Dataproc Workflow Temp and Autoscaling Policy Setup

# import an autoscaling policy
gcloud dataproc autoscaling-policies import ${POLICY_ID} \
    --source=${SCALING_POLICY_SOURCE} \
    --region=${REGION}

gcloud dataproc autoscaling-policies describe ${POLICY_ID} \
    --region=${REGION}

# import a workflow template and test run
## WF TEMP 1 ##
gcloud dataproc workflow-templates import ${TEMPLATE_1_ID} \
    --source=${WT_TEMP_1_SOURCE} \
    --region=${REGION}

gcloud dataproc workflow-templates describe ${TEMPLATE_1_ID} \
    --region=${REGION}

gcloud dataproc workflow-templates instantiate ${TEMPLATE_1_ID} \
    --region=${REGION}

# import a workflow template with args and run test
## WF TEMP 2 ##
gcloud dataproc workflow-templates import ${TEMPLATE_2_ID} \
    --source=${WT_TEMP_2_SOURCE} \
    --region=${REGION}

gcloud dataproc workflow-templates describe ${TEMPLATE_2_ID} \
    --region=${REGION}

gcloud dataproc workflow-templates instantiate ${TEMPLATE_2_ID} \
    --region=${REGION} \
    --parameters=SOURCE_BUCKET="data-validate-bucket",SOURCE_FORMAT="json",DESTINATION="bigquery",DESTINATION_NAME="dataset-validation"

# import a workflow template with optinal params
## WF TEMP 3 ##
gcloud dataproc workflow-templates import ${TEMPLATE_3_ID} \
    --source=${WT_TEMP_3_SOURCE} \
    --region=${REGION}

gcloud dataproc workflow-templates describe ${TEMPLATE_3_ID} \
    --region=${REGION}

gcloud dataproc workflow-templates instantiate ${TEMPLATE_3_ID} \
    --region=${REGION}

## WF TEMP 4 ##
gcloud alpha dataproc workflow-templates import ${TEMPLATE_4_ID} \
    --source=${WF_TEMP_4_SOURCE} \
    --region=${REGION}

gcloud dataproc workflow-templates describe ${TEMPLATE_4_ID} \
    --region=${REGION}

gcloud dataproc workflow-templates instantiate ${TEMPLATE_4_ID} \
    --region=${REGION} \
    --parameters=SOURCE_BUCKET="data-validate-bucket",SOURCE_FORMAT="json",DESTINATION="bigquery",DESTINATION_NAME="dataset-validation",OPT_PARAMS="debugg=true model=RL x=200 y=100"