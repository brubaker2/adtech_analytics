with source as (
    select * from {{ ref('ad_events') }}
),

renamed as (
    select
        event_id,
        ad_id,
        user_id,
        timestamp as event_at,
        cast(timestamp as date) as event_date,
        day_of_week,
        time_of_day,
        event_type
    from source
)

select * from renamed
