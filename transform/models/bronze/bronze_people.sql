-- Bronze: the Cricsheet people register, loaded as text exactly as published.
select
    *,
    current_timestamp as _loaded_at
from read_csv('{{ var("raw_dir") }}/people.csv', header = true, all_varchar = true)
