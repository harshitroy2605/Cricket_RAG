{{ config(materialized='ephemeral') }}
-- Intermediate: one struct per innings, numbered in batting order.
-- Ephemeral = inlined as a CTE into the models that use it; never stored.
select
    match_id,
    info.teams[1]                                       as team1,
    info.teams[2]                                       as team2,
    cast(generate_subscripts(innings, 1) as integer)    as innings_no,
    unnest(innings)                                     as inn
from {{ ref('bronze_matches') }}
