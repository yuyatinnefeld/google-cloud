WITH jobs_by_user_aggregated AS
    (
    select 
        EXTRACT(DATE FROM creation_time) as date, 
        count(query) as query,
        job_type, 
        priority, 
        total_bytes_processed,
        total_slot_ms, 
        total_bytes_billed 
    from {{ref('rawdata_jobs_by_user')}} src
    where total_bytes_processed > 1
    group by date,job_type, priority, total_bytes_processed,total_slot_ms, total_bytes_billed 
    )

select * from jobs_by_user_aggregated