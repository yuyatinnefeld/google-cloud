#!/bin/bash


# 1. Purchase Flex 100 Slots
bq mk \
 --project_id=ADMIN_PROJECT_ID \
 --location=EU \
 --capacity_commitment \
 --plan=FLEX \
 --slots=100

# 2. Create a Reservation
 bq mk \
 --project_id=ADMIN_PROJECT_ID \
 --location=EU \
 --reservation \
 --slots=100 \
 prod

# 3. Assign the project to a reservation
 bq mk \
 --project_id=ADMIN_PROJECT_ID \
 --location=EU \
 --reservation_assignment \
 --reservation_id=ADMIN_PROJECT_ID:US.prod \
 --job_type=QUERY \
 --assignee_id=MY_PROD_PROJECT \
 --assignee_type=PROJECT

# 4. Get the RESERVATION_ASSIGNMENT_ID
bq show \
 --project_id=ADMIN_PROJECT_ID \
 --location=EU \
 --reservation_assignment \
 --job_type=QUERY \
 --assignee_id=MY_PROD_PROJECT \
 --assignee_type=PROJECT

# RESERVATION_ASSIGNMENT_ID looks like "myproject:EU.prod.1234567891011121314"

# 5. Delte the assignment
 bq rm \
  --project_id=ADMIN_PROJECT_ID \
  --location=EU \
  --reservation_assignment \
  RESERVATION_ASSIGNMENT_ID

# 6. Delete the reservation

bq rm \
  --project_id=ADMIN_PROJECT_ID \
  --location=EU \
  --reservation \
  prod

# 6. Get the COMMITMENT_ID
bq ls \
 --capacity_commitment \
 --location=EU \
 --project_id=ADMIN_PROJECT_ID

 # 7. Delete Commitment

 bq rm \
 --project_id=ADMIN_PROJECT_ID \
 --location=EU \
 --capacity_commitment \
 COMMITMENT_ID