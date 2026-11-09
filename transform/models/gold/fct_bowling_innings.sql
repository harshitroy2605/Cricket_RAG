-- Gold: one row per bowler per innings (super overs excluded).
-- Metrics are per ball so The Hundred's 5-ball overs are handled correctly.
with balls as (
    select * from {{ ref('fct_deliveries') }} where not is_super_over
),

stats as (
    select
        match_id, innings_no, bowler_id as player_id, any_value(bowler) as player_name,
        any_value(balls_per_over)                           as balls_per_over,
        count(*) filter (where is_legal_ball)               as legal_balls,
        sum(runs_conceded_by_bowler)                        as runs_conceded,
        count(*) filter (where is_dot_ball)                 as dots,
        sum(wides)                                          as wides,
        sum(noballs)                                        as noballs
    from balls
    group by all
),

wkts as (
    select match_id, innings_no, bowler_id as player_id, count(*) as wickets
    from {{ ref('stg_wickets') }}
    where credited_to_bowler
    group by all
)

select
    s.match_id, s.innings_no, s.player_id, s.player_name,
    m.start_date, m.season, m.match_type, m.format_family, m.gender, m.team_type,
    m.competition, m.venue,
    i.bowling_team, i.batting_team,
    s.balls_per_over, s.legal_balls, s.runs_conceded, s.dots, s.wides, s.noballs,
    coalesce(w.wickets, 0) as wickets
from stats as s
left join wkts as w using (match_id, innings_no, player_id)
join {{ ref('dim_matches') }} as m on m.match_id = s.match_id
join {{ ref('stg_innings') }} as i on i.match_id = s.match_id and i.innings_no = s.innings_no
