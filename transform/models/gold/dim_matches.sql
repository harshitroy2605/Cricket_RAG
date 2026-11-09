-- Gold: match dimension with a canonical competition name (sponsor renames unified).
select
    m.*,
    coalesce(a.competition, m.competition_raw) as competition
from {{ ref('stg_matches') }} as m
left join {{ ref('competition_aliases') }} as a
    on a.competition_raw = m.competition_raw
