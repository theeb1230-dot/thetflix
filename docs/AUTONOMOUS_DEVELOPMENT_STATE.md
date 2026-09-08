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


## Progress 2026-09-08 bootstrap implementation
- PR #1 is open on `feat/bootstrap-unified-app`.
- Added reproducible source materialization from the preserved `theeb_stream-main.zip` archive.
- Rebrands the materialized integration build to `thetflix` and uses integration version `0.1.0+1`.
- Android application IDs are materialized as `com.thetflix.app` and `com.thetflix.tv`.
- Added CI jobs for analyzer/tests, Android Mobile APK, Android TV APK, and unsigned iOS IPA.
- Added a manual GitHub Release workflow that requires all three requested assets before publication.
- Added the first shared playback-provider registry with health state, ranking, duplicate protection, URL construction, and tests.
- Migrated the first Theeb Arab cinema provider, Pomfy, behind that registry. No bulk provider replacement was performed.
- CI runs for the latest PR head are currently queued/pending on GitHub, so PR #1 must not be merged yet.

## Next run
1. Read PR #1 latest CI jobs/logs; fix any failure on the same branch until green.
2. If green, merge PR #1 into main.
3. Start the next provider migration with Videasy only, add tests, then continue provider-by-provider.
4. Begin wiring the unified navigation shell so Turkish, Live, and unified Search become first-class destinations without removing Theeb Stream library/history/download features.
5. Keep release publication blocked until Android Mobile, Android TV, and unsigned iOS artifacts are all proven in CI.


## Progress 2026-09-08 19:50 Asia/Riyadh
- Re-inspected main, branches, PRs, latest commits, Actions runs, and Releases.
- PR #1 remains the only open integration PR.
- Root cause of the previous analyzer failure was confirmed from job logs: renaming the Dart package name from `theeb_stream` to `thetflix` broke existing `package:theeb_stream/...` imports across production code and tests.
- Fixed the root cause on the same branch by preserving the internal Dart package name while keeping the user-facing product identity, Android application IDs, description, and integration version as thetflix.
- Updated the new provider-registry tests to import through the preserved Dart package name.
- Latest CI run for commit `f9f39d632eceed99adc9153a9299b7a464a03de7` is now in progress. It has not yet reached Analyze/Tests, so the PR remains intentionally unmerged.
- GitHub Releases is still empty; no release is considered complete.

## Next run
1. Inspect the latest CI result and logs immediately.
2. Fix any remaining analyzer/test/build failure on PR #1 only.
3. Merge PR #1 only after analyzer, tests, Android Mobile, Android TV, and unsigned iOS build jobs are green.
4. Then migrate Videasy as the next single provider with URL/transport/fallback tests.
5. Continue unified navigation and Theeb Arab Search/Live/Turkish integration without removing Theeb Stream features.


## Progress 2026-09-08 20:21 Asia/Riyadh
- Re-inspected main, all branches, PR history, latest commits, CI runs, Releases, and the autonomous state document.
- PR #1 is merged into `main` as squash commit `0df9bed229a607aff421f970bb33f3738fb85d60`.
- PR #1 CI was fully green before merge: Analyze, Tests, Android Mobile APK, Android TV APK, and unsigned iOS IPA all succeeded from the same head commit.
- GitHub Releases is still empty, so no published release is claimed yet.
- Created `feat/videasy-provider` from current main for the next single-provider migration.
- Added a temporary CI audit to inspect the preserved Theeb Arab source archive and confirmed the actual Videasy endpoint shapes from `lib/features/search/cinema_search_screen.dart`:
  - movie: `https://player.videasy.net/movie/{id}?color=6C63FF`
  - series: `https://player.videasy.net/tv/{id}/{s}/{e}?color=6C63FF`
- Migrated Videasy as the second provider behind `PlaybackProviderRegistry`, preserving Pomfy as the first fallback candidate.
- Added URL-generation and default fallback-order tests for Videasy.
- Removed the temporary provider-audit step after extracting the source-backed endpoint definitions.
- Bumped the integration version to `0.1.1+2` and Android TV versionCode/versionName to `2 / 0.1.1`.
- Latest branch head: `80b44a0f23da1bae699acc16f7d7c46e8df1760b`.
- CI for the updated provider branch is expected to rerun from this head; merge is blocked until the updated Analyze/Tests/platform builds are green.

## Next run
1. Inspect CI for `feat/videasy-provider` at head `80b44a0f23da1bae699acc16f7d7c46e8df1760b`; fix any failure on the same branch.
2. Open/maintain a single PR for the Videasy migration and merge only after Analyze, Tests, Android Mobile, Android TV, and unsigned iOS jobs are green.
3. After merge, verify the same `0.1.1+2` triplet on main and publish a GitHub Release only when all three assets are present from the same commit/version.
4. Audit the next Theeb Arab provider from preserved source before adding it; do not guess endpoint formats.
5. Begin unified navigation work for Turkish, Live, and unified Search while preserving Theeb Stream history, downloads, favorites/library, movies, and series.
