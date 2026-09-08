#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${1:-$ROOT/.workspace/thetflix_app}"
STREAM_ZIP="$ROOT/theeb_stream-main.zip"
ARAB_ZIP="$ROOT/Theeb-Arab-2.2.0-GitHub-IPA-Release-Source.zip"

rm -rf "$OUT"
mkdir -p "$OUT" "$(dirname "$OUT")/sources"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

unzip -q "$STREAM_ZIP" -d "$tmp/stream"
stream_root="$(find "$tmp/stream" -mindepth 1 -maxdepth 1 -type d | head -n1)"
if [[ -z "$stream_root" ]]; then
  echo "Unable to locate Theeb Stream source root" >&2
  exit 1
fi
cp -a "$stream_root"/. "$OUT"/

# Materialize Theeb Arab beside the build tree so integration work can compare
# exact source without modifying the preserved archive.
if [[ -f "$ARAB_ZIP" ]]; then
  mkdir -p "$(dirname "$OUT")/sources/theeb_arab"
  unzip -q "$ARAB_ZIP" -d "$(dirname "$OUT")/sources/theeb_arab"
fi

# Unified product identity/version for the integration line.
python3 - "$OUT" <<'PY'
from pathlib import Path
import sys
root = Path(sys.argv[1])
p = root / "pubspec.yaml"
text = p.read_text()
text = text.replace("description: ذيب ستريم - تطبيق Flutter وAndroid TV للمشاهدة والاستكشاف",
                    "description: thetflix - تطبيق موحد للمشاهدة والبث والبحث", 1)
text = text.replace("version: 2.0.1+15", "version: 0.1.1+2", 1)
p.write_text(text)

main = root / "lib/main.dart"
if main.exists():
    t = main.read_text()
    t = t.replace("title: 'ذيب ستريم'", "title: 'thetflix'")
    t = t.replace("class TheebStreamApp", "class ThetflixApp")
    t = t.replace("const TheebStreamApp", "const ThetflixApp")
    main.write_text(t)

gradle = root / "android/app/build.gradle.kts"
if gradle.exists():
    t = gradle.read_text()
    t = t.replace('applicationId = "com.theebstream.app"', 'applicationId = "com.thetflix.app"')
    gradle.write_text(t)

tv = root / "android/tvapp/build.gradle.kts"
if tv.exists():
    t = tv.read_text()
    t = t.replace('applicationId = "com.theebstream.tv"', 'applicationId = "com.thetflix.tv"')
    t = t.replace('versionCode = 15', 'versionCode = 2')
    t = t.replace('versionName = "2.0.1"', 'versionName = "0.1.1"')
    tv.write_text(t)
PY

# Apply checked-in integration overlay last. This keeps the original archives
# immutable while new thetflix code becomes reviewable and testable.
if [[ -d "$ROOT/overlays" ]]; then
  cp -a "$ROOT/overlays"/. "$OUT"/
fi

echo "Materialized thetflix baseline at $OUT"
