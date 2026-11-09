-- Silver: one row per dismissal record (a ball can carry two).
with w as (
    select
        match_id, innings_no, over_no, ball_seq, bowler, bowler_id,
        unnest(wickets) as wk
    from {{ ref('stg_deliveries') }}
    where n_wickets > 0
),

typed as (
    select
        match_id, innings_no, over_no, ball_seq, bowler, bowler_id,
        coalesce(wk.player_out, wk.playeer_out)   as player_out,   -- one source record has a typo key
        wk.kind                                   as kind,
        nullif(list_transform(wk.fielders, lambda f: f.name), []) as fielders
    from w
)

select
    t.*,
    reg.person_id          as player_out_id,
    wk.credited_to_bowler,
    wk.is_dismissal
from typed as t
left join {{ ref('wicket_kinds') }} as wk on wk.kind = t.kind
left join {{ ref('stg_registry') }} as reg
    on reg.match_id = t.match_id and reg.person_name = t.player_out
