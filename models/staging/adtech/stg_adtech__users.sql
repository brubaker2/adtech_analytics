with source as (
    select * from {{ ref('users') }}
),

deduplicated as (
    select
        *,
        row_number() over (
            partition by user_id
            order by country, location
        ) as _row_num
    from source
),

renamed as (
    select
        user_id,
        user_gender,
        user_age,
        age_group,
        country,
        location,
        interests
    from deduplicated
    where _row_num = 1
)

select * from renamed