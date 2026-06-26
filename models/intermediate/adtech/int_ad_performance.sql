-- Aggregate the event log to one row per ad, pivoting event types into columns.
with events as (
    select * from {{ ref('stg_adtech__ad_events') }}
)

select
    ad_id,
    count(*) as total_events,
    sum(case when event_type = 'Impression' then 1 else 0 end) as impressions,
    sum(case when event_type = 'Click' then 1 else 0 end) as clicks,
    sum(case when event_type = 'Like' then 1 else 0 end) as likes,
    sum(case when event_type = 'Share' then 1 else 0 end) as shares,
    count(distinct user_id) as unique_users,
    min(event_at) as first_event_at,
    max(event_at) as last_event_at
from events
group by ad_id
