import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/auth_bloc.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/pages/track_search.dart';
import 'package:mozaik/states/auth_state.dart';
import 'package:mozaik/states/post_state.dart';
import 'package:shimmer/shimmer.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  String _visibility = 'Public';
  final TextEditingController _postController = TextEditingController();
  String? _spotifyTrackId;
  String? _imageUrl;
  String? _trackName;
  String? _trackImage;
  String? _trackArtist;
  File? _selectedImage;
  bool _isUploading = false;

  void _changeVisibility() {
    setState(() {
      _visibility = _visibility == 'Public' ? 'Private' : 'Public';
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);

        _isUploading = false;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageUrl = null;
    });
  }

  void openTrackSearch() async {
    final selectedTrack = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrackSearch(),
      ),
    );

    if (selectedTrack != null) {
      setState(() {
        _spotifyTrackId = selectedTrack['id'];
        _trackName = selectedTrack['name'];
        _trackArtist = selectedTrack['artist'];
        _trackImage = selectedTrack['imageUrl'];
      });
    }
  }

  Future<void> _publishPost() async {
    if (_isUploading) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to post')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final imageRef = storageRef.child(
          'post_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        await imageRef.putFile(_selectedImage!);
        _imageUrl = await imageRef.getDownloadURL();
      }

      final postBloc = context.read<PostBloc>();
      postBloc.add(CreatePostEvent(
        userId: authState.user.userId,
        content: _postController.text,
        spotifyTrackId: _spotifyTrackId,
        visibility: _visibility.toLowerCase(),
        imageUrl: _imageUrl,
      ));
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to publish: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: const Icon(FluentIcons.arrow_left_24_regular),
        onLeftIconTap: (context) {
          Navigator.pop(context);
        },
        title: "Post",
        rightWidget: TextButton(
          onPressed: _isUploading ? null : _publishPost,
          child: _isUploading
              ? Shimmer.fromColors(
                  baseColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.4),
                  highlightColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  child: Container(
                    width: 64,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : Text(
                  "Publish",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
        ),
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post created successfully!')),
            );
            Navigator.pop(context);
          } else if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return Center(
                  child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: 3,
              ));
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, authState) {
                              if (authState is Authenticated) {
                                return Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: NetworkImage(
                                            authState.user.profilePic),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            authState.user.username,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          GestureDetector(
                                            onTap: _changeVisibility,
                                            child: Row(
                                              children: [
                                                Text(
                                                  _visibility,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                ),
                                                const SizedBox(width: 4),
                                                Icon(
                                                  FluentIcons
                                                      .chevron_down_12_regular,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TextField(
                                controller: _postController,
                                maxLines: null,
                                decoration: InputDecoration(
                                    hintText: 'What\'s on your mind?',
                                    border: InputBorder.none,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          const Spacer(),
                          if (_spotifyTrackId != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: SizedBox(
                                height: 60,
                                child: Row(
                                  children: [
                                    if (_trackImage != null)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Image.network(
                                            _trackImage ?? '',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _trackName ?? 'Unknown Track',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              _trackArtist ?? 'Unknown Artist',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                          FluentIcons.dismiss_24_regular),
                                      onPressed: () {
                                        setState(() {
                                          _spotifyTrackId = null;
                                          _trackName = null;
                                          _trackArtist = null;
                                          _trackImage = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (_selectedImage != null)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          _selectedImage!,
                                          width: double.infinity,
                                          height: 300,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: _removeImage,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black54,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          Container(
                            height: 70,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 0.1,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.backgroundDark
                                      : AppColors.background,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: Icon(
                                    FluentIcons.image_24_regular,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: IconButton(
                                    onPressed: _pickImage,
                                    icon: Icon(
                                      FluentIcons.camera_24_regular,
                                    ),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: IconButton(
                                      onPressed: openTrackSearch,
                                      icon: Icon(
                                        FluentIcons.music_note_1_20_regular,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                ),
                                SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: Icon(
                                    FluentIcons.emoji_24_regular,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: GestureDetector(
                                    onTap: _changeVisibility,
                                    child: Row(
                                      children: [
                                        Text(
                                          _visibility,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          FluentIcons.chevron_down_12_regular,
                                          size: 16,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
