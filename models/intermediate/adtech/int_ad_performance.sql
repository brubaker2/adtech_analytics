-- Aggregate the event log to one row per ad, pivoting event types into columns.
with events as (
    select * from {{ ref('stg_adtech__ad_events') }}
)

select
    ad_id,
    count(*) as total_events,
    {%- set event_types = ['Impression','Click','Like','Share','Comment','Purchase'] -%}

    {% for event_type in event_types %}

        sum(case when event_type = '{{ event_type  }}' then 1 else 0 end) as {{ event_type | lower }}s,

    {% endfor %}   
    count(distinct user_id) as unique_users,
    min(event_at) as first_event_at,
    max(event_at) as last_event_at
from events
group by ad_id