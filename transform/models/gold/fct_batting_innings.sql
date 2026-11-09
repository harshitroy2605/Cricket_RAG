-- Gold: one row per batter per innings (super overs excluded).
-- Includes batters who were run out without facing a ball.
with balls as (
    select * from {{ ref('fct_deliveries') }} where not is_super_over
),

appearances as (
    -- first appearance order gives batting position (striker before non-striker on the same ball)
    select match_id, innings_no, batter_id as player_id, batter as player_name,
           (over_no * 1000 + ball_seq) * 2 as seq
    from balls
    union all
    select b.match_id, b.innings_no, b.non_striker_id, null, (b.over_no * 1000 + b.ball_seq) * 2 + 1
    from balls as b
),

batters as (
    select match_id, innings_no, player_id, any_value(player_name) as player_name, min(seq) as first_seq
    from appearances
    group by all
),

stats as (
    select
        match_id, innings_no, batter_id as player_id,
        sum(runs_batter)                   as runs,
        count(*) filter (where is_ball_faced) as balls_faced,
        count(*) filter (where is_four)    as fours,
        count(*) filter (where is_six)     as sixes,
        count(*) filter (where is_ball_faced and runs_batter = 0) as dots
    from balls
    group by all
),

outs as (
    select match_id, innings_no, player_out_id as player_id,
           bool_or(is_dismissal) as is_out, any_value(kind) as dismissal_kind,
           any_value(bowler) filter (where credited_to_bowler) as dismissed_by_bowler
    from {{ ref('stg_wickets') }}
    group by all
)

select
    b.match_id,
    b.innings_no,
    b.player_id,
    coalesce(b.player_name, p.name)                                   as player_name,
    row_number() over (partition by b.match_id, b.innings_no order by b.first_seq)
                                                                      as batting_position,
    m.start_date, m.season, m.match_type, m.format_family, m.gender, m.team_type,
    m.competition, m.venue,
    i.batting_team, i.bowling_team,
    coalesce(s.runs, 0)        as runs,
    coalesce(s.balls_faced, 0) as balls_faced,
    coalesce(s.fours, 0)       as fours,
    coalesce(s.sixes, 0)       as sixes,
    coalesce(s.dots, 0)        as dots,
    coalesce(o.is_out, false)  as is_out,
    o.dismissal_kind,
    o.dismissed_by_bowler
from batters as b
left join stats as s using (match_id, innings_no, player_id)
left join outs as o using (match_id, innings_no, player_id)
left join {{ ref('stg_people') }} as p on p.person_id = b.player_id
join {{ ref('dim_matches') }} as m on m.match_id = b.match_id
join {{ ref('stg_innings') }} as i on i.match_id = b.match_id and i.innings_no = b.innings_no
