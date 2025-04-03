import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:mozaik/app_colors.dart';

class MusicCard extends StatefulWidget {
  final Map<String, dynamic>? music;
  const MusicCard({super.key, this.music});

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  Color? _backgroundColor;
  static final Map<String, Color> _colorCache = {};
  bool _isGeneratingColor = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.music != null && widget.music!['cover_art'] != null) {
      _extractDominantColor();
    }
  }

  Future<void> _extractDominantColor() async {
    if (_isGeneratingColor) return;
    final String? coverArtUrl = widget.music?['cover_art'];
    if (coverArtUrl == null) return;

    if (_colorCache.containsKey(coverArtUrl)) {
      if (mounted) setState(() => _backgroundColor = _colorCache[coverArtUrl]);
      return;
    }

    _isGeneratingColor = true;

    try {
      final palette = await PaletteGenerator.fromImageProvider(
        ResizeImage(
          CachedNetworkImageProvider(coverArtUrl),
          width: 100,
        ),
        size: Size(100, 100),
        maximumColorCount: 2,
        timeout: Duration(seconds: 2),
      );

      final color = palette.dominantColor?.color ?? AppColors.darkGray;

      if (mounted) {
        setState(() {
          _colorCache[coverArtUrl] = color;
          _backgroundColor = color;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _backgroundColor = AppColors.darkGray);
    } finally {
      _isGeneratingColor = false;
    }
  }

  Color _getTextColor(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.light ? AppColors.primary : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.height * 0.15;
    final textColor = _backgroundColor != null
        ? _getTextColor(_backgroundColor!)
        : Colors.white;

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: _backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: cardHeight,
                height: cardHeight,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  image: widget.music?['cover_art'] != null
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(
                              widget.music!['cover_art']),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.music?['cover_art'] == null
                    ? const Icon(Icons.music_note,
                        size: 40, color: Colors.white70)
                    : null,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.music?['track_name'] ?? 'Unknown Track',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.music?['artist'] ?? 'Unknown Artist',
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_backgroundColor != null)
            Positioned(
              right: 12,
              bottom: 12,
              child: Icon(
                FontAwesomeIcons.spotify,
                color: textColor,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
