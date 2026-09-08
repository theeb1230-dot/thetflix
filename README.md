# thetflix

thetflix is a unified Flutter media application under active integration. The repository currently keeps the original source archives intact and materializes a reproducible working tree in CI while features are merged carefully.

## Product sections
- Home
- Search
- Movies
- Series
- Turkish
- Live TV
- Favorites / library
- Settings

## Current baseline
The first build baseline is materialized from `theeb_stream-main.zip`. Theeb Arab source remains an integration source for Turkish, live television and cinema search. Providers will be migrated gradually with health checks and fallback rather than replaced in one destructive step.

## Build targets
- Android Mobile APK
- Android TV APK
- unsigned iOS IPA

See `docs/THETFLIX_INTEGRATION_PLAN.md` and `docs/AUTONOMOUS_DEVELOPMENT_STATE.md`.
