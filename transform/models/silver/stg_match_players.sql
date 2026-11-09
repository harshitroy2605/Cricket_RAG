-- Silver: the playing XI of each team in each match (includes players who never batted or bowled).
with by_team as (
    select
        match_id,
        unnest(map_keys(info.players))   as team,
        unnest(map_values(info.players)) as names
    from {{ ref('bronze_matches') }}
),

flat as (
    select match_id, team, unnest(names) as player_name from by_team
)

select
    flat.match_id,
    flat.team,
    flat.player_name,
    reg.person_id as player_id
from flat
left join {{ ref('stg_registry') }} as reg
    on reg.match_id = flat.match_id and reg.person_name = flat.player_name
