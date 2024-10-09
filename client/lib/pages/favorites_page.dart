import 'package:client/services/fav_service.dart';
import 'package:client/widgets/reusable/custum_button.dart';
import 'package:flutter/material.dart';

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
                                  isLoading:
                                      false, // No loading indicator for this button
                                  onPressed: () {
                                    removeFromFavorites(wallpaper['id']);
                                  },
                                  labelText: "Remove from favorites",
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
