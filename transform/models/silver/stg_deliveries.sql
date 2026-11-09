-- Silver: one row per ball (11.7M rows). Raw facts only; metrics are derived in gold.
with overs as (
    select match_id, innings_no, unnest(inn.overs) as ov
    from {{ ref('int_innings') }}
),

balls as (
    select
        match_id,
        innings_no,
        ov.over                                              as over_no,
        cast(generate_subscripts(ov.deliveries, 1) as integer) as ball_seq,
        unnest(ov.deliveries)                                as d
    from overs
),

typed as (
    select
        match_id,
        innings_no,
        over_no,
        ball_seq,
        d.actual_delivery,
        d.batter,
        d.bowler,
        d.non_striker,
        d.runs.batter                                   as runs_batter,
        d.runs.extras                                   as runs_extras,
        d.runs.total                                    as runs_total,
        coalesce(d.runs.non_boundary, false)            as non_boundary,      -- a run 4, not a boundary
        coalesce(d.extras.wides, 0)                     as wides,
        coalesce(d.extras.noballs, 0)                   as noballs,
        coalesce(d.extras.byes, 0)                      as byes,
        coalesce(d.extras.legbyes, 0)                   as legbyes,
        coalesce(d.extras.penalty, 0)                   as penalty,
        coalesce(len(d.wickets), 0)                     as n_wickets,         -- can be 2 on one ball
        d.wickets                                       as wickets,
        d.review.by                                     as review_by,
        d.review.decision                               as review_decision,
        d.review.umpires_call                           as review_umpires_call,
        d.replacements                                  as replacements_json  -- impact/concussion subs
    from balls
)

select
    t.*,
    (t.wides = 0 and t.noballs = 0) as is_legal_ball,      -- wides/no-balls are re-bowled
    rb.person_id as batter_id,
    rw.person_id as bowler_id,
    rn.person_id as non_striker_id
from typed as t
left join {{ ref('stg_registry') }} as rb on rb.match_id = t.match_id and rb.person_name = t.batter
left join {{ ref('stg_registry') }} as rw on rw.match_id = t.match_id and rw.person_name = t.bowler
left join {{ ref('stg_registry') }} as rn on rn.match_id = t.match_id and rn.person_name = t.non_striker
