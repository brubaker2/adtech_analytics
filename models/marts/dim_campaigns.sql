select
    campaign_id,
    campaign_name,
    start_date,
    end_date,
    duration_days,
    total_budget
from {{ ref('stg_adtech__campaigns') }}
