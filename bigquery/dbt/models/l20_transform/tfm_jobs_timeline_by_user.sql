WITH jobs_timeline_by_user_aggregated AS
    (
    select 
        EXTRACT(DATE FROM job_creation_time) as creation_time, 
        EXTRACT(DATE FROM job_start_time) as start_time, 
        EXTRACT(DATE FROM job_end_time) as end_time, 
        job_id,
        job_type,
        priority,
        total_bytes_processed,
        total_bytes_billed
    from {{ref('rawdata_jobs_timeline_by_user')}} src
    where total_bytes_processed > 1
    )

select * from jobs_timeline_by_user_aggregated