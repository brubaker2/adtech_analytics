select
    a.ad_id,
    a.campaign_id,
    c.campaign_name,
    a.ad_platform,
    a.ad_type,
    a.target_gender,
    a.target_age_group,
    a.target_interests
from {{ ref('stg_adtech__ads') }} as a
left join {{ ref('stg_adtech__campaigns') }} as c
    on a.campaign_id = c.campaign_id
