import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/services/spotify_service.dart';

class TrackSearch extends StatefulWidget {
  const TrackSearch({super.key});

  @override
  State<TrackSearch> createState() => _TrackSearchState();
}

class _TrackSearchState extends State<TrackSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  bool isSearchEmpty = true;
  Timer? _debounceTimer;

  void _debounceSearch() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        searchSpotify(_searchController.text);
      } else {
        setState(() {
          searchResults = [];
          isSearchEmpty = true;
        });
      }
    });
  }

  Future<void> searchSpotify(String query) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final results = await SpotifyService.searchTracks(query);

      setState(() {
        searchResults = results;
        isSearchEmpty = results.isEmpty;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching Spotify: $e')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      searchResults = [];
      isSearchEmpty = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_debounceSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_debounceSearch);
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: const Icon(FluentIcons.arrow_left_24_regular),
        onLeftIconTap: (context) {
          Navigator.pop(context);
        },
        title: "",
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a song...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(FluentIcons.dismiss_24_regular),
                              onPressed: _clearSearch,
                            )
                          : null,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(FluentIcons.search_24_regular),
                  onPressed: () {
                    searchSpotify(_searchController.text);
                  },
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: isSearchEmpty
                      ? const Center(
                          child: Text(
                            'No results found.',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.teupeGray,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final track = searchResults[index];
                            return ListTile(
                              leading: track['imageUrl'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        track['imageUrl'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(
                                      FluentIcons.music_note_1_20_regular),
                              title: Text(track['name']),
                              subtitle: Text(track['artist']),
                              onTap: () {
                                Navigator.pop(context, {
                                  'id': track['id'],
                                  'name': track['name'],
                                  'artist': track['artist'],
                                  'imageUrl': track['imageUrl'],
                                });
                              },
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
