import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_riverpod/providers/navigation_provider.dart';
import 'package:moviedb_riverpod/views/movie/movie_page.dart';
import 'package:moviedb_riverpod/views/search/search_page.dart';
import 'package:moviedb_riverpod/views/setting/setting_page.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const List<Widget> _pages = [MoviePage(), SearchPage(), SettingPage()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mengambil nilai index saat ini dari provider
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        // Update index menggunakan provider
        onTap: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
