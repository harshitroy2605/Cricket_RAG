-- Silver: the people register with the cross-site ids we may use later.
select
    identifier   as person_id,
    name,
    unique_name,
    key_cricinfo,
    key_cricbuzz,
    key_bcci
from {{ ref('bronze_people') }}
