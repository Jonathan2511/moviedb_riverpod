import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_riverpod/providers/theme_provider.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Dark Mode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Switch(
              value: isDarkTheme,
              onChanged: (value) {
                log('Start Toggle Theme');
                ref.read(themeProvider.notifier).state = value;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  log('Finish Toggle Theme');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
