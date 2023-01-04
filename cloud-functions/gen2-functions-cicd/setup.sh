##### storage func test

# prep
BUCKET_NAME=demo-yuya-bucket-2023
FILE_PATH=hello-demo-path/123/demo.json
gsutil mb gs://$BUCKET_NAME

# upload file for testing
gsutil cp demo.json gs://$BUCKET_NAME/$FILE_PATH
gsutil rm gs://$BUCKET_NAME/$FILE_PATH

# clean up
gsutil rm -r gs://$BUCKET_NAME/ && gsutil rb gs://$BUCKET_NAME

##### bigquery func test

# prep
PROJECT_ID=yuyatinnefele-dev
DATASET_ID=demo_dataset
TABLE_ID=demo_table

bq --location=europe-west1 mk \
    --dataset \
    --description="$DATASET_ID" \
    $DATASET_ID

bq mk \
  -t \
  --description "$TABLE_ID" \
  $DATASET_ID.$TABLE_ID \
  qtr:STRING,year:STRING


# insert data
INSERT demo_dataset.demo_table (qtr, year)
VALUES('guten tag', '2010'),
      ('yo bro', '2023')

# clean up
bq rm -t $DATASET_ID.$TABLE_ID
bq rm -r -d $DATASET_ID


# clean up func
FUNCTION_NAME="bq-trigger-func"
gcloud functions delete $FUNCTION_NAME --region=europe-west1 --gen2
FUNCTION_NAME="gcs-trigger-func"
gcloud functions delete $FUNCTION_NAME --region=europe-west1 --gen2

