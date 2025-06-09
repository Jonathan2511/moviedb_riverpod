import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_riverpod/providers/search_provider.dart';
import 'package:moviedb_riverpod/views/movie/component/movie_card.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch search query dan search results
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);
    final searchNotifier = ref.read(searchResultsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Movies')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // Update search query
                ref.read(searchQueryProvider.notifier).state = value;

                // Lakukan pencarian
                searchNotifier.searchMovies(value);
              },
            ),
          ),
          Expanded(
            child:
                searchQuery.isEmpty
                    ? const Center(
                      child: Text(
                        'Start typing to search movies',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : searchResults.isEmpty
                    ? const Center(
                      child: Text(
                        'No movies found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final movieCard = MovieCard(
                          movie: searchResults[index],
                        );
                        if (index == 0) {
                          log('Build Search Result');
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            log('Finish Search Result');
                          });
                        }
                        return movieCard;
                      },
                    ),
            // : SingleChildScrollView(
            //   child: Builder(
            //     builder: (context) {
            //       log('Build Search Result');
            //       final cards =
            //           searchResults
            //               .map((movie) => MovieCard(movie: movie))
            //               .toList();
            //       WidgetsBinding.instance.addPostFrameCallback((_) {
            //         log('Finish Search Result');
            //       });
            //       return Column(children: cards);
            //     },
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
