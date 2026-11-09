{#- Use the custom schema name as-is (bronze/silver/gold) instead of dbt's default
    "<target_schema>_<custom>" (e.g. main_bronze). Standard override in medallion projects. -#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}{{ target.schema }}{%- else -%}{{ custom_schema_name | trim }}{%- endif -%}
{%- endmacro %}
