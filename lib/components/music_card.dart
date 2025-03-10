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

  @override
  void initState() {
    super.initState();
    _generatePalette();
  }

  Future<void> _generatePalette() async {
    if (widget.music != null && widget.music!['cover_art'] != null) {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(widget.music!['cover_art']),
      );

      setState(() {
        _backgroundColor = paletteGenerator.dominantColor?.color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? songTitle = widget.music?['track_name'];
    final String? artist = widget.music?['artist'];
    final String? imageUrl = widget.music?['cover_art'];

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: _backgroundColor ?? AppColors.darkGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      songTitle!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      artist!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              FontAwesomeIcons.spotify,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
