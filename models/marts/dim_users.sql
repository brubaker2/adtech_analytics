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
        {%- set event_types = ['Impression','Click','Like','Share'] -%}

        {% for event_type in event_types %}

            sum(case when event_type = '{{ event_type  }}' then 1 else 0 end) as {{ event_type | lower }}s,

        {% endfor %}    
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