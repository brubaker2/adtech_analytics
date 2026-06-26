with perf as (
    select * from {{ ref('int_ad_performance') }}
),

ads as (
    select * from {{ ref('stg_adtech__ads') }}
)

select
    p.ad_id,
    a.campaign_id,
    a.ad_platform,
    a.ad_type,
    p.impressions,
    p.clicks,
    p.likes,
    p.shares,
    p.unique_users,
    p.total_events,
    -- click-through rate: clicks per impression
    safe_divide(p.clicks, p.impressions) as ctr,
    -- engagement rate: (likes + shares) per impression
    safe_divide(p.likes + p.shares, p.impressions) as engagement_rate,
    p.first_event_at,
    p.last_event_at
from perf as p
left join ads as a
    on p.ad_id = a.ad_id
