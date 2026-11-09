-- Unnesting must not drop or duplicate wickets.
select *
from (
    select
        (select count(*) from {{ ref('stg_wickets') }})        as wicket_rows,
        (select sum(n_wickets) from {{ ref('stg_deliveries') }}) as expected
)
where wicket_rows <> expected
