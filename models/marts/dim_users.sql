select
    user_id,
    user_gender,
    user_age,
    age_group,
    country,
    location,
    interests
from {{ ref('stg_adtech__users') }}
