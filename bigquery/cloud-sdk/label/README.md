# Labeling BigQuery Resources

## About
A label is a key-value pair that helps you organize your Google Cloud BigQuery resources. 

## Benefits
- You can attach a label to each resource, then filter the resources based on their labels. 
- Information about labels is forwarded to the billing system, so you can break down your billing charges by label.

## Common uses of labels

Team labels
- team:research, team:dwh, team:analytics, team:etl

Conponent labels
- component:ingest, component:store, compenent:analyze, component:explore

Environment labels
- environment:prod, environment:dev, environment:stg

State labels
- sate:active, state:readytodelete, state:archive

## Adding labels

### Create a dataset with label
```bash
KEY1=team
KEY2=component
VALUE1=yt
VALUE2=store

bq mk \
 --label ${KEY1}:${VALUE1} ${KEY2}:${VALUE2} \
 --location=${LOCATION} \
 --project_id=${PROJECT_ID} \
${DATASET}
```

### Add (Update) labels
```bash
KEY1=team
KEY2=component
VALUE1=yt
VALUE2=store

# add labels to a dataset
bq update \
--set_label ${KEY1}:${VALUE1} \
--set_label ${KEY2}:${VALUE2} \
${DATASET}

# add a label to a table
bq update --set_label ${KEY1}:${VALUE1} ${DATASET}.${TABLE}

# add a label to a view
bq update --set_label ${KEY1}:${VALUE1} ${DATASET}.${VIEW}


# add a label to a query job
bq query \
--label ${KEY1}:${VALUE1} \
--nouse_legacy_sql \
'SELECT
    column1, column2
FROM
`${DATASET}.${TABLE}`'

```

## Viewing labels
```bash
bq show --format=pretty [RESOURCE_ID]

bq show --format=pretty ds_eu
bq show -j --format=pretty etl_job_123_fa177109-8e78-4710-b8a3-cfacf8df3785

```
[RESOURCE_ID] is a valid dataset, table, view, or job ID.

## Filter using labels
```bash
bq ls --filter "labels.${KEY1}:${VALUE1}"
bq ls --filter "labels.${KEY1}:${VALUE1}" --project_id ${PROJECT_ID}
```

## Delete labels
```bash
bq update --clear_label ${KEY1} ${DATASET}


bq update \
--clear_label ${KEY1} \
--clear_label ${KEY2} \
${DATASET}
```