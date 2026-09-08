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
