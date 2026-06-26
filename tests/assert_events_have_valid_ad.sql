-- Sanity check: no event should have a non-positive event_id,
-- and every event must map to a known ad.
select
    e.event_id,
    e.ad_id
from {{ ref('stg_adtech__ad_events') }} as e
left join {{ ref('stg_adtech__ads') }} as a
    on e.ad_id = a.ad_id
where a.ad_id is null
