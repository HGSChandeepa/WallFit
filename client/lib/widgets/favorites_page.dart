import 'package:client/services/fav_service.dart';
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
        SnackBar(
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
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : favoriteWallpapers.isEmpty
              ? Center(
                  child: Text("No favorite wallpapers found."),
                )
              : ListView.builder(
                  itemCount: favoriteWallpapers.length,
                  itemBuilder: (context, index) {
                    final wallpaper = favoriteWallpapers[index];
                    return ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
                      title: Text(wallpaper['description']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          removeFromFavorites(wallpaper['id']);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
