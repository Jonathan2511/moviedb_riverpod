import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_riverpod/repositories/movie_repository.dart';
import '../models/movie_model.dart';

final movieServiceProvider = Provider((ref) => MovieService());

final moviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((
  ref,
) {
  final notifier = MoviesNotifier(ref);
  notifier.fetchMovies(20); // Default fetch 20 movies saat provider dibuat
  return notifier;
});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  MoviesNotifier(this._ref) : super([]);

  final Ref _ref;
  int _maxMovies = 20;

  Future<void> fetchMovies(int count) async {
    state = [];
    _maxMovies = count;

    if (_maxMovies <= 2500) {
      // Fetch data if less than or equal to 2500
      int maxPage = (_maxMovies / 20).ceil();
      List<Movie> allMovies = [];
      try {
        for (int page = 1; page <= maxPage; page++) {
          final movies = await _ref
              .read(movieServiceProvider)
              .fetchMovies(page: page);
          allMovies.addAll(movies);
        }
      } catch (e) {
        throw Exception('Error fetching movies: $e');
      }
      state = allMovies.take(_maxMovies).toList();
    } else {
      // Duplication logic for > 2500 movies
      // First, fetch 2500 movies
      int maxPage = (2500 / 20).ceil();
      List<Movie> allMovies = [];
      try {
        for (int page = 1; page <= maxPage; page++) {
          final movies = await _ref
              .read(movieServiceProvider)
              .fetchMovies(page: page);
          allMovies.addAll(movies);
        }
      } catch (e) {
        throw Exception('Error fetching movies: $e');
      }

      // If the required number of movies is more than 2500, duplicate the data
      int repeatCount = (_maxMovies / 2500).ceil();
      List<Movie> duplicatedMovies = [];
      for (int i = 0; i < repeatCount; i++) {
        duplicatedMovies.addAll(allMovies);
      }

      // Trim the duplicated list to match the required movie count
      state = duplicatedMovies.take(_maxMovies).toList();
    }
  }
}
