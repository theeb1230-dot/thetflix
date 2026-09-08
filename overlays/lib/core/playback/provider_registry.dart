enum PlaybackTransport { direct, hls, embed }

enum ProviderHealth { unknown, healthy, degraded, down }

class PlaybackProvider {
  final String id;
  final String displayName;
  final String movieTemplate;
  final String seriesTemplate;
  final PlaybackTransport transport;
  final int rank;
  final ProviderHealth health;
  final Duration timeout;

  const PlaybackProvider({
    required this.id,
    required this.displayName,
    required this.movieTemplate,
    required this.seriesTemplate,
    required this.transport,
    required this.rank,
    this.health = ProviderHealth.unknown,
    this.timeout = const Duration(seconds: 8),
  });

  String buildUrl({
    required int tmdbId,
    bool series = false,
    int season = 1,
    int episode = 1,
  }) {
    final template = series ? seriesTemplate : movieTemplate;
    return template
        .replaceAll('{id}', '$tmdbId')
        .replaceAll('{s}', '$season')
        .replaceAll('{e}', '$episode');
  }

  PlaybackProvider copyWith({
    ProviderHealth? health,
    int? rank,
  }) {
    return PlaybackProvider(
      id: id,
      displayName: displayName,
      movieTemplate: movieTemplate,
      seriesTemplate: seriesTemplate,
      transport: transport,
      rank: rank ?? this.rank,
      health: health ?? this.health,
      timeout: timeout,
    );
  }
}

class PlaybackProviderRegistry {
  final List<PlaybackProvider> _providers;

  PlaybackProviderRegistry([Iterable<PlaybackProvider> providers = const []])
      : _providers = List.of(providers);

  List<PlaybackProvider> get providers => List.unmodifiable(_providers);

  void register(PlaybackProvider provider) {
    if (_providers.any((item) => item.id == provider.id)) {
      throw StateError('Provider id already registered: ${provider.id}');
    }
    _providers.add(provider);
  }

  List<PlaybackProvider> rankedCandidates() {
    final result = List<PlaybackProvider>.of(_providers);
    int healthWeight(ProviderHealth health) => switch (health) {
          ProviderHealth.healthy => 0,
          ProviderHealth.unknown => 1,
          ProviderHealth.degraded => 2,
          ProviderHealth.down => 3,
        };
    result.sort((a, b) {
      final byHealth = healthWeight(a.health).compareTo(healthWeight(b.health));
      return byHealth != 0 ? byHealth : a.rank.compareTo(b.rank);
    });
    return result;
  }

  void recordHealth(String id, ProviderHealth health) {
    final index = _providers.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _providers[index] = _providers[index].copyWith(health: health);
  }
}

/// First migrated Theeb Arab cinema provider.
///
/// Providers are intentionally added one by one and validated before the next
/// source is enabled, preventing a bulk replacement from breaking playback.
const pomfyProvider = PlaybackProvider(
  id: 'pomfy',
  displayName: 'Pomfy',
  movieTemplate: 'https://api.pomfy.stream/filme/{id}#cor:00F2FE',
  seriesTemplate: 'https://api.pomfy.stream/serie/{id}/{s}/{e}#cor:00F2FE',
  transport: PlaybackTransport.embed,
  rank: 10,
);

PlaybackProviderRegistry createDefaultProviderRegistry() =>
    PlaybackProviderRegistry([pomfyProvider]);
