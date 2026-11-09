-- runs.total in the source must equal runs.batter + runs.extras.
select match_id, innings_no, over_no, ball_seq
from {{ ref('stg_deliveries') }}
where runs_total <> runs_batter + runs_extras
