"""Phase 1: download Cricsheet data into data/raw. Safe to re-run (skips existing files)."""

import shutil
import urllib.request
import zipfile

from third_umpire.config import get_settings

FILES = {
    "all_json.zip": "https://cricsheet.org/downloads/all_json.zip",  # every match, ball-by-ball
    "people.csv": "https://cricsheet.org/register/people.csv",  # player/official register
}
HEADERS = {"User-Agent": "third-umpire-data-fetch/0.1"}


def download(url: str, dest) -> None:
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req, timeout=120) as resp, open(dest, "wb") as f:
        shutil.copyfileobj(resp, f)


def main() -> None:
    raw = get_settings().raw_dir
    raw.mkdir(parents=True, exist_ok=True)

    for name, url in FILES.items():
        dest = raw / name
        if dest.exists():
            print(f"skip {name} (already downloaded)")
            continue
        print(f"downloading {url} ...")
        download(url, dest)
        print(f"  -> {dest.name}: {dest.stat().st_size / 1e6:.1f} MB")

    out = raw / "all_json"
    if not out.exists():
        print("unzipping ...")
        with zipfile.ZipFile(raw / "all_json.zip") as z:
            z.extractall(out)
    print(f"{len(list(out.glob('*.json')))} match files in {out}")


if __name__ == "__main__":
    main()
