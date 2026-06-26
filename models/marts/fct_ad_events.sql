select
    event_id,
    ad_id,
    user_id,
    event_at,
    event_date,
    day_of_week,
    time_of_day,
    event_type
from {{ ref('stg_adtech__ad_events') }}
