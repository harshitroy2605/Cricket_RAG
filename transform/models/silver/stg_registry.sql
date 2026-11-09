-- Silver: per-match name -> Cricsheet person id (players, umpires, referees).
-- Names are not unique across cricket; ids are. Everything downstream joins on ids.
select
    match_id,
    unnest(map_keys(info.registry.people))   as person_name,
    unnest(map_values(info.registry.people)) as person_id
from {{ ref('bronze_matches') }}
