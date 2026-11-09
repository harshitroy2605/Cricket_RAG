-- Gold: one row per person with the number of matches played.
select
    p.person_id as player_id,
    p.name,
    p.unique_name,
    p.key_cricinfo,
    count(distinct mp.match_id) as matches_played
from {{ ref('stg_people') }} as p
left join {{ ref('stg_match_players') }} as mp
    on mp.player_id = p.person_id
group by all
