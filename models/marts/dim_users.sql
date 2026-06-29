with users as (
    select * from {{ ref('stg_adtech__users') }}
),

events as (
    select * from {{ ref('stg_adtech__ad_events') }}
),

user_ads as (
    select
        user_id,
        count(*) as total_events,
        sum(case when event_type = 'Impression' then 1 else 0 end) as impressions,
        sum(case when event_type = 'Click' then 1 else 0 end) as clicks,
        sum(case when event_type = 'Like' then 1 else 0 end) as likes,
        sum(case when event_type = 'Share' then 1 else 0 end) as shares,
        count(distinct ad_id) as unique_ads
from events
group by user_id
),
final as (
    select
        user_ads.user_id,
        user_ads.total_events,
        user_ads.impressions,
        user_ads.clicks,
        user_ads.likes,
        user_ads.shares,
        user_ads.unique_ads,
        users.user_gender,
        users.user_age,
        users.age_group,
        users.country,
        users.location,
        users.interests
    from user_ads
    inner join users on user_ads.user_id = users.user_id
)
select * from final