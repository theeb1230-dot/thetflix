import 'package:flutter_test/flutter_test.dart';
import 'package:theeb_stream/core/playback/provider_registry.dart';

void main() {
  test('Pomfy builds movie URL', () {
    expect(
      pomfyProvider.buildUrl(tmdbId: 550),
      'https://api.pomfy.stream/filme/550#cor:00F2FE',
    );
  });

  test('Pomfy builds series URL with season and episode', () {
    expect(
      pomfyProvider.buildUrl(
        tmdbId: 1399,
        series: true,
        season: 2,
        episode: 7,
      ),
      'https://api.pomfy.stream/serie/1399/2/7#cor:00F2FE',
    );
  });

  test('Videasy builds movie and series URLs', () {
    expect(
      videasyProvider.buildUrl(tmdbId: 550),
      'https://player.videasy.net/movie/550?color=00F2FE',
    );
    expect(
      videasyProvider.buildUrl(
        tmdbId: 1399,
        series: true,
        season: 3,
        episode: 4,
      ),
      'https://player.videasy.net/tv/1399/3/4?color=00F2FE',
    );
  });

  test('default registry contains providers in configured fallback order', () {
    final ids = createDefaultProviderRegistry()
        .rankedCandidates()
        .map((provider) => provider.id)
        .toList();
    expect(ids, ['pomfy', 'videasy']);
  });

  test('healthy providers rank ahead of unknown providers', () {
    final registry = PlaybackProviderRegistry([
      pomfyProvider,
      const PlaybackProvider(
        id: 'fallback',
        displayName: 'Fallback',
        movieTemplate: 'https://example.test/movie/{id}',
        seriesTemplate: 'https://example.test/tv/{id}/{s}/{e}',
        transport: PlaybackTransport.embed,
        rank: 1,
      ),
    ]);
    registry.recordHealth('pomfy', ProviderHealth.healthy);
    expect(registry.rankedCandidates().first.id, 'pomfy');
  });

  test('duplicate provider ids are rejected', () {
    final registry = createDefaultProviderRegistry();
    expect(() => registry.register(pomfyProvider), throwsStateError);
  });
}
