"""Integration test: run the whole dbt pipeline on a real match file and check the scorecard.

Uses tests/fixtures/1000851.json (South Africa v Australia, Perth, Nov 2016) and a
throwaway DuckDB file, so it never touches data/processed.
"""

import csv
import json
import os
import shutil
import subprocess
from pathlib import Path

import duckdb
import pytest

ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "tests" / "fixtures" / "1000851.json"


@pytest.fixture(scope="module")
def built_db(tmp_path_factory):
    tmp = tmp_path_factory.mktemp("pipeline")
    raw = tmp / "raw"
    (raw / "all_json").mkdir(parents=True)
    shutil.copy(FIXTURE, raw / "all_json" / FIXTURE.name)

    # minimal people register covering everyone in the fixture
    match = json.loads(FIXTURE.read_text(encoding="utf-8"))
    with open(raw / "people.csv", "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(
            ["identifier", "name", "unique_name", "key_bcci", "key_cricbuzz", "key_cricinfo"]
        )
        for name, pid in match["info"]["registry"]["people"].items():
            w.writerow([pid, name, name, "", "", ""])

    db = tmp / "test.duckdb"
    env = {**os.environ, "TU_DUCKDB_PATH": str(db), "TU_DUCKDB_MEMORY_LIMIT": "1GB"}
    result = subprocess.run(
        ["dbt", "build", "--vars", json.dumps({"raw_dir": raw.as_posix()})],
        cwd=ROOT / "transform",
        env=env,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stdout[-3000:]
    return db


def test_batting_matches_real_scorecard(built_db):
    con = duckdb.connect(str(built_db), read_only=True)
    rows = dict(
        con.sql("""
        select player_name, runs from gold.fct_batting_innings
        where match_id = '1000851' and innings_no = 4
    """).fetchall()
    )
    assert rows["UT Khawaja"] == 97
    assert rows["DA Warner"] == 35
    assert rows["PM Nevill"] == 60


def test_bowling_matches_real_scorecard(built_db):
    con = duckdb.connect(str(built_db), read_only=True)
    balls, runs, wkts = con.execute("""
        select legal_balls, runs_conceded, wickets from gold.fct_bowling_innings
        where match_id = '1000851' and innings_no = 4 and player_name = 'K Rabada'
    """).fetchone()
    assert (runs, wkts) == (92, 5)  # Rabada 5/92
    assert balls == 186  # 31 overs
