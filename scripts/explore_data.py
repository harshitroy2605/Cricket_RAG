"""Phase 1: profile every Cricsheet match file to learn the real structure before designing tables.

Prints counts of which keys/values appear and how often. Run:
    uv run python scripts/explore_data.py > data/processed/profile.txt
"""

import csv
import json
from collections import Counter, defaultdict

from third_umpire.config import get_settings


def main() -> None:
    s = get_settings()
    files = sorted((s.raw_dir / "all_json").glob("*.json"))

    top_keys, info_keys, innings_keys, delivery_keys = Counter(), Counter(), Counter(), Counter()
    runs_keys, extras_types, wicket_kinds, wicket_keys = Counter(), Counter(), Counter(), Counter()
    data_version, match_type, gender, team_type = Counter(), Counter(), Counter(), Counter()
    type_gender, events, outcome_keys, results = Counter(), Counter(), Counter(), Counter()
    methods, balls_per_over = Counter(), Counter()
    date_range = defaultdict(lambda: ["9999", "0000"])
    n_deliveries, failed, sample_wicket = 0, [], None

    for f in files:
        try:
            m = json.loads(f.read_text(encoding="utf-8"))
        except Exception as e:  # noqa: BLE001 - we want to count any failure
            failed.append((f.name, str(e)[:80]))
            continue

        top_keys.update(m.keys())
        data_version[m.get("meta", {}).get("data_version")] += 1
        info = m.get("info", {})
        info_keys.update(info.keys())
        mt, g = info.get("match_type"), info.get("gender")
        match_type[mt] += 1
        gender[g] += 1
        type_gender[(mt, g)] += 1
        team_type[info.get("team_type")] += 1
        balls_per_over[info.get("balls_per_over")] += 1
        events[info.get("event", {}).get("name", "<no event>")] += 1
        out = info.get("outcome", {})
        outcome_keys.update(out.keys())
        if "result" in out:
            results[out["result"]] += 1
        if "method" in out:
            methods[out["method"]] += 1
        d = (info.get("dates") or ["?"])[0]
        lo_hi = date_range[mt]
        lo_hi[0], lo_hi[1] = min(lo_hi[0], d), max(lo_hi[1], d)

        for inn in m.get("innings", []):
            innings_keys.update(inn.keys())
            for over in inn.get("overs", []):
                for dl in over.get("deliveries", []):
                    n_deliveries += 1
                    delivery_keys.update(dl.keys())
                    runs_keys.update(dl.get("runs", {}).keys())
                    extras_types.update(dl.get("extras", {}).keys())
                    for w in dl.get("wickets", []):
                        wicket_kinds[w.get("kind")] += 1
                        wicket_keys.update(w.keys())
                        if sample_wicket is None and "fielders" in w and "review" in dl:
                            sample_wicket = (f.name, dl)

    n = len(files)
    pct = lambda c: f"{c:>6} ({100 * c / max(n, 1):5.1f}%)"  # noqa: E731

    def show(title: str, counter: Counter, top: int = 30, as_pct: bool = False) -> None:
        print(f"\n## {title}")
        for k, v in counter.most_common(top):
            print(f"  {str(k):<45} {pct(v) if as_pct else v}")

    print(f"# Files: {n} | parsed: {n - len(failed)} | failed: {len(failed)}")
    print(f"# Deliveries: {n_deliveries:,}")
    for name, err in failed[:10]:
        print(f"  FAILED {name}: {err}")
    show("Top-level keys (files containing)", top_keys, as_pct=True)
    show("meta.data_version", data_version)
    show("info keys (files containing)", info_keys, 60, as_pct=True)
    show("match_type", match_type)
    show("gender", gender)
    show("match_type x gender", type_gender)
    show("team_type", team_type)
    show("balls_per_over", balls_per_over)
    print("\n## Date range by match_type")
    for k, (lo, hi) in sorted(date_range.items(), key=lambda x: str(x[0])):
        print(f"  {str(k):<10} {lo} -> {hi}")
    show("Top events", events, 30)
    show("outcome keys", outcome_keys)
    show("outcome.result (no winner)", results)
    show("outcome.method", methods)
    show("innings keys", innings_keys)
    show("delivery keys", delivery_keys)
    show("runs keys", runs_keys)
    show("extras types", extras_types)
    show("wicket kinds", wicket_kinds)
    show("wicket keys", wicket_keys)
    if sample_wicket:
        print(f"\n## Sample delivery with wicket + review ({sample_wicket[0]})")
        print(json.dumps(sample_wicket[1], indent=2))

    people = s.raw_dir / "people.csv"
    if people.exists():
        with people.open(encoding="utf-8") as fh:
            rows = list(csv.reader(fh))
        print(f"\n## people.csv: {len(rows) - 1} people, {len(rows[0])} columns")
        print("  columns:", rows[0])
        for r in rows[1:3]:
            print("  ", r)


if __name__ == "__main__":
    main()
