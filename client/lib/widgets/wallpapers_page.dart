import 'package:client/widgets/wallpaper_details.dart';
import 'package:flutter/material.dart';
import 'package:client/services/wallpaper_service.dart';
import 'package:client/models/wallpaper.dart';

class WallpapersPage extends StatefulWidget {
  @override
  _WallpapersPageState createState() => _WallpapersPageState();
}

class _WallpapersPageState extends State<WallpapersPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Wallpaper> _wallpapers = [];
  bool _isLoading = false;

  void _searchWallpapers() async {
    setState(() {
      _isLoading = true;
    });

    String searchQuery = _searchController.text;
    try {
      List<Wallpaper> wallpapers =
          await WallpaperService().searchWallpapers(searchQuery);
      setState(() {
        _wallpapers = wallpapers;
      });
    } catch (e) {
      print("Error fetching wallpapers: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search Wallpapers",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchWallpapers,
                ),
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: _wallpapers.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, // Changed to a single column
                            childAspectRatio: 2 / 3,
                          ),
                          itemCount: _wallpapers.length,
                          itemBuilder: (context, index) {
                            final wallpaper = _wallpapers[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to details page when wallpaper is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WallpaperDetailsPage(
                                      wallpaper: wallpaper,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        wallpaper.url,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        wallpaper.description,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        "By ${wallpaper.photographer}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            "No wallpapers found. Try a different search.",
                          ),
                        ),
                ),
        ],
      ),
    );
  }
}
