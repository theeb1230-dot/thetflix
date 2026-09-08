# thetflix Integration Plan

## Product goal
Create one polished Flutter application named **thetflix** that combines the mature library/discovery/download capabilities of Theeb Stream with the Turkish, cinema search/playback, and live channel capabilities of Theeb Arab.

## Non-negotiable preservation rules
- Do not remove working Theeb Stream features merely to simplify the merge.
- Keep Turkish content isolated as its own section.
- Keep live television isolated as its own section.
- Preserve favorites/library, watch history, downloads, recommendations, settings, movies, and series.
- Merge Theeb Arab search as an additional search/playback path, not as a destructive replacement of the existing catalog search.
- Add playback providers gradually with validation. Never swap all providers in one commit.

## Target navigation
### Mobile
Bottom navigation / compact adaptive shell:
1. Home
2. Search
3. Movies
4. Series
5. Turkish
6. Live
7. Library/Favorites
8. Settings

The exact presentation can collapse secondary destinations under a More/Library destination when screen width is constrained, but all destinations remain first-class screens.

### Android TV
- Left rail or top navigation with strong focus rings.
- Explicit FocusNode ordering.
- D-pad friendly cards, server selectors, dialogs, and player controls.
- No touch-only interaction requirement.

## Visual system
- Background: near-black navy.
- Primary accent: electric cyan.
- Secondary accent: controlled violet for playback/action emphasis.
- High contrast white typography.
- Cyan focus outlines on TV and selected navigation states.
- Avoid ornamental glow that harms readability.
- Identity must read `thetflix`; old product names may remain only in migration documentation or source-attribution comments.

## Playback architecture
Create a provider abstraction with fields equivalent to:
- id
- displayName
- media type support
- transport type: direct / HLS / embed
- health status
- last check time
- latency
- failure reason
- rank

Playback resolution flow:
1. Build provider candidates for the requested title/episode.
2. Prefer providers recently confirmed healthy.
3. Attempt one provider at a time.
4. On failure, record reason and try next candidate.
5. Do not erase a provider simply because one transient check failed.

## Theeb Arab provider migration
The source contains a cinema provider catalog with many embed endpoints. Migrate them in controlled batches, ideally one provider per product-affecting PR/commit once the registry exists. Each migrated provider should have:
- URL generation tests
- timeout handling
- transport classification
- health-check result handling
- fallback verification

## Live television
Port live channel functionality with:
- search
- categories
- selected-channel persistence where appropriate
- HLS-native playback
- retry bounded by policy
- fullscreen
- next/previous channel remote actions
- Android TV D-pad navigation

Channel filtering should be product/configuration driven, not hard-coded around sectarian or viewpoint exclusions. Content curation rules belong in a neutral configurable allow/block layer.

## Search
Unify two kinds of search under one UX:
- Theeb Stream catalog/TMDB discovery
- Theeb Arab cinema search/playback

Results should expose their source and available playback/download actions without confusing duplicate cards.

## Builds and releases
Every release-ready product build must create:
- Android Mobile APK
- Android TV APK
- unsigned iOS IPA

GitHub Actions should upload artifacts on CI and attach the final three files to GitHub Releases when a release tag is created.

## Versioning
Start the unified application at `0.1.0+1` while integration is incomplete. Increase build number for each product-impacting change and semantic version for user-visible milestones.

## Definition of done for first public test release
- App launches on Android Mobile, Android TV, and unsigned iOS build completes.
- Home/library features preserved.
- Turkish section works.
- Live section works.
- Unified search works.
- At least the first validated Theeb Arab playback providers work through the new provider registry.
- CI green.
- GitHub Release includes all three platform assets.
