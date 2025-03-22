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
  bool _isPaletteGenerated = false;
  static final Map<String, Color> _paletteCache = {};

  @override
  void initState() {
    super.initState();
    _generatePalette();
  }

  @override
  void didUpdateWidget(MusicCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.music != oldWidget.music) {
      _generatePalette();
    }
  }

  Future<void> _generatePalette() async {
    if (widget.music != null && widget.music!['cover_art'] != null) {
      final String coverArtUrl = widget.music!['cover_art'];

      if (_paletteCache.containsKey(coverArtUrl)) {
        if (mounted) {
          setState(() {
            _backgroundColor = _paletteCache[coverArtUrl];
            _isPaletteGenerated = true;
          });
        }
        return;
      }

      try {
        final PaletteGenerator paletteGenerator =
            await PaletteGenerator.fromImageProvider(
          NetworkImage(coverArtUrl),
        );

        _paletteCache[coverArtUrl] =
            paletteGenerator.dominantColor?.color ?? AppColors.darkGray;

        if (mounted) {
          setState(() {
            _backgroundColor = _paletteCache[coverArtUrl];
            _isPaletteGenerated = true;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isPaletteGenerated = true;
          });
        }
      }
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

    final textColor = _backgroundColor != null
        ? _getTextColor(_backgroundColor!)
        : Colors.white;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: _isPaletteGenerated
                ? _backgroundColor ?? AppColors.darkGray
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: _isPaletteGenerated
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                        child: Image.network(
                          imageUrl!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
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
        if (_isPaletteGenerated)
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
