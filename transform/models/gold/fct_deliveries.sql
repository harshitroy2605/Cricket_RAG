-- Gold: every ball with its match and innings context, plus derived flags.
-- The main table for text-to-SQL in Phase 5.
select
    d.match_id,
    d.innings_no,
    d.over_no,
    d.ball_seq,
    m.start_date,
    m.season,
    m.match_type,
    m.format_family,
    m.gender,
    m.team_type,
    m.competition,
    m.venue,
    m.venue_id,
    m.balls_per_over,
    i.batting_team,
    i.bowling_team,
    i.is_super_over,
    d.batter_id,
    d.batter,
    d.bowler_id,
    d.bowler,
    d.non_striker_id,
    d.runs_batter,
    d.runs_extras,
    d.runs_total,
    d.wides,
    d.noballs,
    d.byes,
    d.legbyes,
    d.is_legal_ball,
    d.wides = 0                                                     as is_ball_faced,  -- no-balls count as faced
    d.runs_batter = 4 and not d.non_boundary                        as is_four,
    d.runs_batter = 6 and not d.non_boundary                        as is_six,
    d.runs_batter + d.wides + d.noballs                             as runs_conceded_by_bowler,
    d.is_legal_ball and d.runs_batter + d.wides + d.noballs = 0     as is_dot_ball,
    d.n_wickets,
    case
        when m.format_family = 't20' and m.balls_per_over = 6 then
            case when d.over_no < 6 then 'powerplay' when d.over_no < 15 then 'middle' else 'death' end
        when m.format_family = 'one_day' then
            case when d.over_no < 10 then 'powerplay' when d.over_no < 40 then 'middle' else 'death' end
    end                                                             as phase
from {{ ref('stg_deliveries') }} as d
join {{ ref('dim_matches') }} as m on m.match_id = d.match_id
join {{ ref('stg_innings') }} as i on i.match_id = d.match_id and i.innings_no = d.innings_no
