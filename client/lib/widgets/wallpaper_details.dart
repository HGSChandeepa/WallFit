import 'package:client/models/wallpaper.dart';
import 'package:client/pages/login.dart';
import 'package:client/services/auth.dart';
import 'package:client/services/fav_service.dart';
import 'package:client/widgets/reusable/custum_button.dart';
import 'package:flutter/material.dart';

class WallpaperDetailsPage extends StatelessWidget {
  final Wallpaper wallpaper;

  WallpaperDetailsPage({required this.wallpaper});

  void _addToFavorites(Wallpaper wallpaper, BuildContext context) async {
    try {
      await FavoriteService().addToFavorites(
        id: wallpaper.id,
        url: wallpaper.url,
        description: wallpaper.description,
        photographer: wallpaper.photographer,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("Failed to add to favorites: $e");

      // Check if the error indicates a token issue
      if (e.toString().contains("No valid token found") ||
          e.toString().contains("Failed to add to favorites")) {
        AuthService().logout();
        // Navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        print("User logged out due to invalid token.");
      } else {
        // Show an error message for other issues
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error adding to favorites. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallpaper Details"),
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
            padding: const EdgeInsets.all(
                16.0), // Increased padding for better spacing
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
                    fontSize: 12  ,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  wallpaper.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  isLoading: false, // No loading state for this button
                  onPressed: () {
                    _addToFavorites(wallpaper, context);
                  },
                  labelText: "Add to Favorites",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
