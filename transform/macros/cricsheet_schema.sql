{#-
  Data contract for Cricsheet match JSON (data_version 1.3.0), built from the Phase 1 profile.
  DuckDB's JSON reader uses it to parse each file ONCE into native nested columns.
  - Keys whose names are data (team names, person names) are MAPs.
  - Rare, irregular sub-objects are kept as JSON so nothing is lost.
  - A type mismatch fails the load instead of silently corrupting stats.
-#}
{% macro cricsheet_columns() -%}
{
    'meta': 'STRUCT(data_version VARCHAR, created VARCHAR, revision INTEGER)',
    'info': 'STRUCT(
        balls_per_over INTEGER,
        bowl_out JSON,
        city VARCHAR,
        dates VARCHAR[],
        event STRUCT(name VARCHAR, match_number VARCHAR, stage VARCHAR, "group" VARCHAR, sub_name VARCHAR),
        gender VARCHAR,
        match_type VARCHAR,
        match_type_number INTEGER,
        missing JSON,
        officials JSON,
        outcome STRUCT(
            winner VARCHAR, result VARCHAR, method VARCHAR, eliminator VARCHAR, bowl_out VARCHAR,
            "by" STRUCT(runs INTEGER, wickets INTEGER, innings INTEGER)
        ),
        overs INTEGER,
        player_of_match VARCHAR[],
        players MAP(VARCHAR, VARCHAR[]),
        registry STRUCT(people MAP(VARCHAR, VARCHAR), venues MAP(VARCHAR, VARCHAR)),
        season VARCHAR,
        supersubs JSON,
        team_type VARCHAR,
        teams VARCHAR[],
        toss STRUCT(decision VARCHAR, winner VARCHAR, uncontested BOOLEAN),
        venue VARCHAR
    )',
    'innings': 'STRUCT(
        team VARCHAR,
        declared BOOLEAN,
        forfeited BOOLEAN,
        super_over BOOLEAN,
        target STRUCT(runs INTEGER, overs DOUBLE),
        penalty_runs STRUCT(pre INTEGER, post INTEGER),
        absent_hurt VARCHAR[],
        powerplays JSON,
        miscounted_overs JSON,
        overs STRUCT(
            "over" INTEGER,
            deliveries STRUCT(
                actual_delivery VARCHAR,
                batter VARCHAR,
                bowler VARCHAR,
                non_striker VARCHAR,
                runs STRUCT(batter INTEGER, extras INTEGER, total INTEGER, non_boundary BOOLEAN),
                extras STRUCT(wides INTEGER, noballs INTEGER, byes INTEGER, legbyes INTEGER, penalty INTEGER),
                wickets STRUCT(
                    player_out VARCHAR, playeer_out VARCHAR, kind VARCHAR,
                    fielders STRUCT(name VARCHAR, substitute BOOLEAN)[]
                )[],
                review STRUCT("by" VARCHAR, umpire VARCHAR, batter VARCHAR, decision VARCHAR, "type" VARCHAR, umpires_call BOOLEAN),
                replacements JSON,
                "over" JSON
            )[]
        )[]
    )[]'
}
{%- endmacro %}
