-- Silver: one row per innings with its flags.
select
    match_id,
    innings_no,
    inn.team                                                as batting_team,
    case when inn.team = team1 then team2 else team1 end    as bowling_team,
    coalesce(inn.super_over, false)                         as is_super_over,     -- excluded from normal stats
    coalesce(inn.declared, false)                           as declared,
    coalesce(inn.forfeited, false)                          as forfeited,         -- innings with no overs
    inn.target.runs                                         as target_runs,
    inn.target.overs                                        as target_overs,
    inn.penalty_runs.pre                                    as penalty_runs_pre,
    inn.penalty_runs.post                                   as penalty_runs_post,
    inn.absent_hurt                                         as absent_hurt,
    inn.powerplays                                          as powerplays_json,
    inn.miscounted_overs                                    as miscounted_overs_json
from {{ ref('int_innings') }}
