-- Silver: one typed row per match. Every Phase 1 quirk is handled explicitly (see comments).
select
    b.match_id,
    b.meta.data_version                                    as data_version,
    b.info.match_type                                      as match_type,
    mt.format_family,
    b.info.gender                                          as gender,
    b.info.team_type                                       as team_type,
    b.info.event.name                                      as competition_raw,     -- null for ~0.4%
    b.info.event.match_number                              as event_match_number,
    b.info.event.stage                                     as event_stage,
    b.info.season                                          as season,
    cast(b.info.dates[1] as date)                          as start_date,          -- DuckDB lists are 1-based
    cast(b.info.dates[-1] as date)                         as end_date,            -- multi-day: last listed day
    len(b.info.dates)                                      as n_days,
    b.info.venue                                           as venue,
    map_values(b.info.registry.venues)[1]                  as venue_id,
    b.info.city                                            as city,                -- null for ~7%
    b.info.teams[1]                                        as team1,
    b.info.teams[2]                                        as team2,
    b.info.toss.winner                                     as toss_winner,
    b.info.toss.decision                                   as toss_decision,
    coalesce(
        b.info.outcome.result,
        case when b.info.outcome.winner is not null then 'win' end
    )                                                      as result,              -- win | draw | tie | no result
    b.info.outcome.winner                                  as winner,
    b.info.outcome.by.runs                                 as win_by_runs,
    b.info.outcome.by.wickets                              as win_by_wickets,
    coalesce(b.info.outcome.by.innings, 0) > 0             as win_by_innings,
    b.info.outcome.method                                  as method,              -- D/L, VJD, Awarded, ...
    coalesce(b.info.outcome.eliminator, b.info.outcome.bowl_out)
                                                           as eliminator,          -- tie-breaker winner
    b.info.balls_per_over                                  as balls_per_over,      -- 5 = The Hundred
    b.info.overs                                           as overs_limit,         -- null for multi-day
    b.info.player_of_match                                 as player_of_match,
    b.info.missing is not null                             as has_missing_data,    -- ~12% flagged
    b.info.missing                                         as missing_json
from {{ ref('bronze_matches') }} as b
left join {{ ref('match_types') }} as mt
    on mt.match_type = b.info.match_type
