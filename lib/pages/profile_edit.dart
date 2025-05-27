import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/auth_bloc.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/blocs/user_bloc.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/components/rounded_button.dart';
import 'package:mozaik/components/rounded_rectangle_button.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/events/auth_event.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/events/user_event.dart';
import 'package:mozaik/services/image_service.dart';
import 'package:mozaik/states/auth_state.dart';
import 'package:mozaik/states/post_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mozaik/states/user_state.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({
    super.key,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final ImageService _imageService = ImageService();
  late TextEditingController _usernameController;
  late TextEditingController _handleController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  bool _isEdited = false;
  File? _newProfilePicFile;
  File? _newCoverPhotoFile;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _usernameController =
          TextEditingController(text: authState.user.username);
      _handleController = TextEditingController(text: authState.user.handle);
      _bioController = TextEditingController(text: authState.user.bio ?? '');
      _emailController = TextEditingController(text: authState.user.email);

      _usernameController.addListener(_checkForChanges);
      _handleController.addListener(_checkForChanges);
      _bioController.addListener(_checkForChanges);
      _emailController.addListener(_checkForChanges);
    }
  }

  void _checkForChanges() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final user = authState.user;
      setState(() {
        _isEdited = _usernameController.text != user.username ||
            _handleController.text != user.handle ||
            _bioController.text != (user.bio ?? '') ||
            _emailController.text != user.email ||
            _newProfilePicFile != null ||
            _newCoverPhotoFile != null;
      });
    }
  }

  Future<void> _saveChanges() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated || !_isEdited) return;
    String? token = authState.token;
    print('token is $token');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String? profilePicUrl;
      String? coverPhotoUrl;

      if (_newProfilePicFile != null) {
        profilePicUrl = await _imageService.uploadImage(
            _newProfilePicFile!,
            'profile_pictures/${authState.user.username}_${DateTime.now().millisecondsSinceEpoch}.jpg',
            token);
      }

      if (_newCoverPhotoFile != null) {
        coverPhotoUrl = await _imageService.uploadImage(
            _newCoverPhotoFile!,
            'cover_photos/${authState.user.username}_${DateTime.now().millisecondsSinceEpoch}.jpg',
            token);
      }

      context.read<AuthBloc>().add(UserProfileUpdateRequested(
            userId: authState.user.userId,
            profilePic: profilePicUrl,
            cover: coverPhotoUrl,
            username: _usernameController.text,
            handle: _handleController.text,
            bio: _bioController.text,
            email: _emailController.text,
          ));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        setState(() {
          _isEdited = false;
          _newProfilePicFile = null;
          _newCoverPhotoFile = null;
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _changeProfilePicture() async {
    try {
      final File? image = await _imageService.pickImage();
      if (image == null || !mounted) return;

      setState(() {
        _newProfilePicFile = image;
        _isEdited = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select image: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _changeCoverPhoto() async {
    try {
      final File? image = await _imageService.pickImage();
      if (image == null || !mounted) return;

      setState(() {
        _newCoverPhotoFile = image;
        _isEdited = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select image: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildProfileImage(Authenticated authState) {
    final profilePicUrl = authState.user.profilePic;
    if (_newProfilePicFile != null) {
      return Image.file(_newProfilePicFile!, fit: BoxFit.cover);
    } else if (profilePicUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: profilePicUrl,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return const Icon(Icons.person);
    }
  }

  Widget _buildCoverImage(Authenticated authState) {
    if (_newCoverPhotoFile != null) {
      return Image.file(
        _newCoverPhotoFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 140,
      );
    } else if (authState.user.cover.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: authState.user.cover,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 140,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        height: 140,
      );
    }
  }

  Widget _buildInfoRow({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: title == "Bio" ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Icon(
              FluentIcons.chevron_right_16_regular,
              size: 16,
              color: Theme.of(context).hintColor,
            ),
          ],
        ),
      ),
    );
  }

  void _editField(String fieldName) {
    TextEditingController controller;
    switch (fieldName) {
      case "Username":
        controller = _usernameController;
        break;
      case "Handle":
        controller = _handleController;
        break;
      case "Bio":
        controller = _bioController;
        break;
      case "Email":
        controller = _emailController;
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $fieldName"),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkForChanges();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _handleController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetAndPop(BuildContext context) async {
    context.read<PostBloc>().add(ClearUserPosts());
    context.read<PostBloc>().add(FetchPosts());
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<PostBloc>().add(FetchPostsByUser(authState.user.userId));
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _resetAndPop(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'Edit Profile',
            rightWidget: _isEdited
                ? TextButton(
                    onPressed: _saveChanges,
                    child: Container(
                      width: 64,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Save Changes",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  )
                : null),
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return CustomScrollView(
                slivers: [
                  if (authState is Authenticated) ...[
                    SliverAppBar(
                      expandedHeight: 180,
                      collapsedHeight: 0,
                      toolbarHeight: 0,
                      pinned: true,
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? AppColors.background
                              : AppColors.backgroundDark,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            GestureDetector(
                              onTap: _changeCoverPhoto,
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      _buildCoverImage(authState),
                                      Container(
                                        height: 140,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.8),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "Tap to change cover",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? AppColors.background
                                          : AppColors.backgroundDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: _changeProfilePicture,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 80),
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 88,
                                              height: 88,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                            ),
                                            Positioned(
                                              top: 2,
                                              left: 2,
                                              child: Container(
                                                width: 84,
                                                height: 84,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? AppColors.background
                                                      : AppColors
                                                          .backgroundDark,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              left: 4,
                                              child: ClipOval(
                                                child: SizedBox(
                                                  width: 80,
                                                  height: 80,
                                                  child: OverflowBox(
                                                    maxWidth: 84,
                                                    maxHeight: 84,
                                                    child: _buildProfileImage(
                                                        authState),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 3,
                                              right: 3,
                                              child: GestureDetector(
                                                onTap: _changeProfilePicture,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    FontAwesomeIcons.pen,
                                                    size: 14,
                                                    color: Theme.of(context)
                                                        .dialogBackgroundColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 48.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About you",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              _buildInfoRow(
                                title: "Username",
                                value: _usernameController.text,
                                onTap: () => _editField("Username"),
                              ),
                              _buildInfoRow(
                                title: "Handle",
                                value: "@${_handleController.text}",
                                onTap: () => _editField("Handle"),
                              ),
                              _buildInfoRow(
                                title: "Bio",
                                value: _bioController.text ?? '',
                                onTap: () => _editField("Bio"),
                              ),
                              _buildInfoRow(
                                title: "Email",
                                value: _emailController.text,
                                onTap: () => _editField("Email"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ] else
                    SliverFillRemaining(
                      child: Center(
                        child: authState is Unauthenticated
                            ? const Text("Log in to see your profile")
                            : const Text('No user data available.'),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
