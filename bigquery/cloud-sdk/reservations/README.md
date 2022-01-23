# BigQuery Reservations
Reservations are BigQuery cost management platform

## Price Model
- On-Demand: pay by slots (this is default)
- Flat-Rate: reserve dedicated slot amout (montly, annual, flex)

## Steps (Flat Rate)
1. Commitments: purchase slots
2. Reservations: allocate slots to the team / workloads / department
3. Assignments: you can use the assignments projects

## On-demand Cost
- 1 TiB = $5.0

## Flat-Rate Cost (Frankfurt)
- Monthly slots plan: 100 slots/Month = $2600
- Annual slots plan: 100 slots/Month = $2210
- Flex slots plan: 100 slots/hour = $5.2

## Benetifs of Flex Slots
using the following cases:
    - cyclical periods of high demand (Batch Time) 
    - split ETL / DS jobs 
    - evaluations for your BigQuery slots consume
    - Ad-hoc analytics and data science workloads
    - query bigger than 1 TiB table

- You can  combine Flex Slots with existing annual and monthly commitments for the cost tuning

- You can use flat-rate in one region and on-demand in another region


## Manage reservations

[Get Started](https://github.com/yuyatinnefeld/gcp/tree/master/sdk/bigquery/reservations/slots_manage.sh)

More Info: https://cloud.google.com/bigquery/docs/reservations-tasks


## Slots & Perforamnce Digram
![GitHub Logo](/images/slots.png)

- Query: 3.15 TiB
- 20 Sec by 2000 Slots
- 2000 Sec by 500 Slots

![GitHub Logo](/images/slots2.png)


## Manage Workloads

### Essential factors when to use flat-rate/on-demand:
- Cost
- Efficiency
- Predictability
- Resources

### Google Recommendation (Admin project)
- creating one administration project for all reservations.
- Using a single administration project simplifies for the billing and allocate slots management
- Enable the BigQuery Reservations API only on the administration project
- [Google Info](https://cloud.google.com/bigquery/docs/reservations-workload-management)

### Monitoring - Slots Usage
- Using INFORMATION_SCHEMA for jobs
- Cloud Logging
- Jobs API
- BigQuery Audit logs
- BigQuery slot estimator (data for the past 7 days)

## Slots
- Slots = individuell compute workers that process your query

- if you purchase 2,000 BigQuery slots, your queries in aggregate are limited to using 2,000 virtual CPUs at any given time

