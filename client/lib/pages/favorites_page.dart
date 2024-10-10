import 'package:client/services/fav_service.dart';
import 'package:client/widgets/reusable/custum_button.dart';
import 'package:flutter/material.dart';
import 'package:async_wallpaper/async_wallpaper.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoriteService _favoriteService = FavoriteService();
  List<dynamic> favoriteWallpapers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchFavoriteWallpapers();
  }

  Future<void> fetchFavoriteWallpapers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<dynamic> favorites = await _favoriteService.getFavorites();
      setState(() {
        favoriteWallpapers = favorites;
      });
    } catch (e) {
      print("Error fetching favorite wallpapers: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> removeFromFavorites(String id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _favoriteService.removeFromFavorites(id);
      setState(() {
        favoriteWallpapers.removeWhere((wallpaper) => wallpaper['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("Error removing from favorites: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _setWallpaper(String url) async {
    setState(() {
      _isLoading = true; // Optionally show a loading indicator
    });

    try {
      bool result = await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
        goToHome: true,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result
              ? 'Wallpaper set successfully!'
              : 'Failed to set wallpaper.'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Rebuild the UI after setting wallpaper
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    } catch (e) {
      print("Failed to set wallpaper: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to set wallpaper. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        _isLoading = false; // Hide loading indicator if error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteWallpapers.isEmpty
              ? const Center(
                  child: Text("No favorite wallpapers found."),
                )
              : ListView.builder(
                  itemCount: favoriteWallpapers.length,
                  itemBuilder: (context, index) {
                    final wallpaper = favoriteWallpapers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.network(
                            wallpaper['url'],
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wallpaper['description'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Photographer: ${wallpaper['photographer']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CustomButton(
                                  isLoading: false,
                                  onPressed: () {
                                    removeFromFavorites(wallpaper['id']);
                                  },
                                  labelText: "Remove from favorites",
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  isLoading: false,
                                  onPressed: () {
                                    _setWallpaper(wallpaper['url']);
                                  },
                                  labelText: "Set as wallpaper",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
