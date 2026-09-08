# thetflix Autonomous Development State

## Current objective
Build a unified Flutter application from Theeb Stream and Theeb Arab without deleting required features, targeting Android Mobile, Android TV, and unsigned iOS IPA releases.

## Repository state at bootstrap
- Default branch: `main`
- Working branch: `feat/bootstrap-unified-app`
- Source archives currently stored in repository root:
  - `theeb_stream-main.zip`
  - `Theeb-Arab-2.2.0-GitHub-IPA-Release-Source.zip`
  - `maxstream-main.zip`
- No Pull Requests existed when this state file was created.

## Architecture decisions
1. Use Theeb Stream as the application foundation because it already contains movies, series, details, downloads, history, recommendations, provider health, and release workflows.
2. Port Theeb Arab features as isolated feature modules instead of replacing the existing application shell wholesale.
3. Preserve separate sections for home, Turkish content, live channels, unified search, movies, series, favorites/library, and settings.
4. Build a shared playback/provider layer that can rank providers, perform health checks, and fallback progressively instead of bulk-replacing all servers.
5. Keep Android TV focus/D-pad behavior explicit and separate from touch interaction.
6. Any product-affecting change must bump version/build before release.

## First implementation tranche
- Establish unified product identity `thetflix`.
- Create a production development plan in-repo.
- Add CI/release workflows capable of eventually producing Android Mobile APK, Android TV APK, and unsigned iOS IPA.
- Port the Theeb Arab search provider catalog and Turkish/live modules gradually behind adapters.

## Release acceptance criteria
A release is not considered complete until GitHub Releases contains all three testable assets:
- Android Mobile APK
- Android TV APK
- unsigned iOS IPA

## Next run
1. Materialize the Flutter source tree from Theeb Stream foundation into this repository.
2. Rebrand app/package-facing product strings to `thetflix` without deleting functional modules.
3. Integrate Theeb Arab search provider definitions behind a provider registry with health/fallback metadata.
4. Add live and Turkish sections to the main navigation while preserving existing Theeb Stream screens.
5. Run analyzer/tests/build CI and fix failures from logs on the same branch before merge.
