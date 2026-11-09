-- An innings cannot have more than 10 real dismissals (retirements excluded).
select match_id, innings_no, count(*) as dismissals
from {{ ref('stg_wickets') }}
where is_dismissal
group by all
having count(*) > 10
