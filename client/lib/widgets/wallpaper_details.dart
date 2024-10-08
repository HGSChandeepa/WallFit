import 'package:flutter/material.dart';
import 'package:client/models/wallpaper.dart';

class WallpaperDetailsPage extends StatelessWidget {
  final Wallpaper wallpaper;

  WallpaperDetailsPage({required this.wallpaper});

  void _addToFavorites(Wallpaper wallpaper) {
    // Add logic to save the wallpaper to favorites (e.g., using a local database or API call)
    print("Added to favorites: ${wallpaper.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallpaper Details"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              wallpaper.url,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallpaper.description,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Photographer: ${wallpaper.photographer}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _addToFavorites(wallpaper);
                  },
                  icon: const Icon(Icons.favorite),
                  label: const Text("Add to Favorites"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
