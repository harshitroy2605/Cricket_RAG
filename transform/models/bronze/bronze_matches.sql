-- Bronze: raw Cricsheet match documents, one row per file, structure unchanged.
-- Parsed once against an explicit schema (macros/cricsheet_schema.sql), so later
-- layers read native nested columns instead of re-parsing JSON text.
select
    regexp_extract(filename, '([^/\\]+)\.json$', 1) as match_id,
    filename                                        as source_file,
    meta,
    info,
    innings,
    current_timestamp                               as _loaded_at
from read_json(
    '{{ var("raw_dir") }}/all_json/*.json',
    format = 'auto',
    filename = true,
    columns = {{ cricsheet_columns() }}
)
