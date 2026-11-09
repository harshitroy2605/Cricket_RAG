-- Each ball must appear exactly once.
select match_id, innings_no, over_no, ball_seq, count(*) as n
from {{ ref('stg_deliveries') }}
group by all
having count(*) > 1
