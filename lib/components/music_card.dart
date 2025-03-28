import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mozaik/app_colors.dart';
import 'package:palette_generator/palette_generator.dart';

class MusicCard extends StatefulWidget {
  final Map<String, dynamic>? music;
  const MusicCard({super.key, this.music});

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  Color? _backgroundColor;
  static final Map<String, Color> _paletteCache = {};
  ImageStream? _imageStream;
  bool _isGeneratingPalette = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _imageStream?.removeListener(ImageStreamListener((_, __) {}));
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.music != null && widget.music!['cover_art'] != null) {
      precacheImage(
        CachedNetworkImageProvider(widget.music!['cover_art']),
        context,
      );
      getMainColorFromUrl();
    }
  }

  Future<void> getMainColorFromUrl([int timeout = 1000]) async {
    if (_isGeneratingPalette) return;
    if (widget.music == null || widget.music!['cover_art'] == null) return;
    _isGeneratingPalette = true;

    final String coverArtUrl = widget.music!['cover_art'];

    if (_paletteCache.containsKey(coverArtUrl)) {
      if (mounted &&
          _backgroundColor !=
              (_paletteCache[coverArtUrl] ?? AppColors.darkGray)) {
        setState(() => _backgroundColor = _paletteCache[coverArtUrl]);
      }
      return;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;

      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(coverArtUrl),
        size: const Size(200, 200),
        maximumColorCount: 5,
      ).timeout(Duration(milliseconds: timeout));

      final color = paletteGenerator.dominantColor?.color ?? AppColors.darkGray;
      _paletteCache[coverArtUrl] = color;
      if (mounted) setState(() => _backgroundColor = color);
    } catch (e) {
      if (mounted) setState(() => _backgroundColor = AppColors.darkGray);
    } finally {
      _isGeneratingPalette = false;
    }
  }

  Color _getTextColor(Color backgroundColor) {
    final Brightness brightness =
        ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.light ? AppColors.primary : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final String? songTitle = widget.music?['track_name'];
    final String? artist = widget.music?['artist'];
    final String? imageUrl = widget.music?['cover_art'];
    final cardHeight = MediaQuery.of(context).size.height * 0.15;

    final textColor = _backgroundColor != null
        ? _getTextColor(_backgroundColor!)
        : Colors.white;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: cardHeight,
          decoration: BoxDecoration(
            color: _backgroundColor != null
                ? _backgroundColor ?? AppColors.darkGray
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: _backgroundColor != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: cardHeight,
                      height: cardHeight,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                memCacheWidth: 200,
                                memCacheHeight: 200,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.music_note),
                              )
                            : const Icon(Icons.music_note),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              songTitle!,
                              style: TextStyle(
                                fontSize: 18,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              artist!,
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor.withValues(alpha: 0.8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                ),
        ),
        if (_backgroundColor != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                FontAwesomeIcons.spotify,
                color: textColor,
              ),
            ),
          ),
      ],
    );
  }
}
