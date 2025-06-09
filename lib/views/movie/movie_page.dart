import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_riverpod/views/movie/component/movie_card.dart';
import 'package:moviedb_riverpod/providers/movie_provider.dart';

class MoviePage extends ConsumerWidget {
  const MoviePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(moviesProvider);
    final moviesNotifier = ref.read(moviesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies (${movies.length})'),
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              moviesNotifier.fetchMovies(value);
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(value: 20, child: Text('Show 20 movies')),
                PopupMenuItem(value: 60, child: Text('Show 60 movies')),
                PopupMenuItem(value: 100, child: Text('Show 100 movies')),
                PopupMenuItem(value: 200, child: Text('Show 200 movies')),
                PopupMenuItem(value: 500, child: Text('Show 500 movies')),
                PopupMenuItem(value: 1000, child: Text('Show 1000 movies')),
                PopupMenuItem(value: 2500, child: Text('Show 2500 movies')),
                PopupMenuItem(value: 5000, child: Text('Show 5000 movies')),
                PopupMenuItem(value: 10000, child: Text('Show 10000 movies')),
              ];
            },
          ),
        ],
      ),
      body:
          movies.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async {
                  await moviesNotifier.fetchMovies(movies.length);
                },
                child: ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movieCard = MovieCard(movie: movies[index]);
                    if (index == 4) {
                      log('Build Movie');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        log('Finish Build Movie');
                      });
                    }
                    return movieCard;
                  },
                ),
                // child: SingleChildScrollView(
                //   child: Column(
                //     children:
                //         movies.asMap().entries.map((entry) {
                //           final index = entry.key;
                //           final movie = entry.value;
                //           if (index == 0) {
                //             log('Build Movie');
                //           }
                //           if (index == movies.length - 1) {
                //             WidgetsBinding.instance.addPostFrameCallback((_) {
                //               log('Finish Build Movie');
                //             });
                //           }
                //           return MovieCard(movie: movie);
                //         }).toList(),
                //   ),
                // ),
              ),
    );
  }
}
