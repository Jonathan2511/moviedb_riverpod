import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_riverpod/models/movie_model.dart';
import 'package:moviedb_riverpod/providers/movie_provider.dart';

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final searchResultsProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, List<Movie>>((ref) {
  return SearchNotifier(ref);
});

class SearchNotifier extends StateNotifier<List<Movie>> {
  final Ref _ref;

  SearchNotifier(this._ref) : super([]);

  Future<void> searchMovies(String query) async {
    // Jika query kosong, kembalikan list kosong
    if (query.isEmpty) {
      state = [];
      return;
    }

    try {
      // Dapatkan seluruh movie dari provider movies
      final allMovies = _ref.read(moviesProvider);

      // Lakukan pencarian berdasarkan query
      final searchResults = allMovies
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      state = searchResults;
    } catch (e) {
      // Handle error
      state = [];
      SnackBar(
        content: Text(e.toString()),
      );
    }
  }
}
