"""Compare the gold tables with well-known real-world numbers.

dbt tests prove the data is internally consistent; this checks it matches reality.
Run from the project root:
    uv run python scripts/sanity_check.py
"""

import duckdb

from third_umpire.config import get_settings

QUERIES = {
    "Top 5 IPL run-scorers": """
        select player_name, sum(runs) as runs, count(*) as innings
        from gold.fct_batting_innings
        where competition = 'Indian Premier League'
        group by 1 order by 2 desc limit 5
    """,
    "Top 5 IPL wicket-takers": """
        select player_name, sum(wickets) as wickets, count(*) as innings
        from gold.fct_bowling_innings
        where competition = 'Indian Premier League'
        group by 1 order by 2 desc limit 5
    """,
    "Row counts": """
        select 'matches' as tbl, count(*) as n from gold.dim_matches
        union all select 'deliveries', count(*) from gold.fct_deliveries
        union all select 'batting innings', count(*) from gold.fct_batting_innings
        union all select 'bowling innings', count(*) from gold.fct_bowling_innings
    """,
}


def main() -> None:
    db = get_settings().processed_dir / "cricket.duckdb"
    con = duckdb.connect(str(db), read_only=True)
    for title, sql in QUERIES.items():
        print(f"\n## {title}")
        for row in con.execute(sql).fetchall():
            print("  ", *row)
    print(f"\nDatabase size: {db.stat().st_size / 1e6:.0f} MB")


if __name__ == "__main__":
    main()
