import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/blocs/profile_bloc.dart';
import 'package:mozaik/blocs/theme_bloc.dart';
import 'package:mozaik/blocs/user_bloc.dart';
import 'package:mozaik/components/bottom_nav_bar.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/components/floating_action_button.dart';
import 'package:mozaik/components/profile_icon.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/events/profile_event.dart';
import 'package:mozaik/events/theme_event.dart';
import 'package:mozaik/pages/direct_message.dart';
import 'package:mozaik/pages/discover.dart';
import 'package:mozaik/pages/home.dart';
import 'package:mozaik/pages/login.dart';
import 'package:mozaik/pages/messages.dart';
import 'package:mozaik/pages/new_post.dart';
import 'package:mozaik/pages/notifications.dart';
import 'package:mozaik/pages/pick_username.dart';
import 'package:mozaik/pages/profile.dart';
import 'package:mozaik/pages/register.dart';
import 'package:mozaik/states/profile_state.dart';
import 'package:mozaik/states/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('app_theme');
  final initialTheme =
      savedTheme?.contains('dark') ?? false ? ThemeMode.dark : ThemeMode.light;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PostBloc()..add(FetchPosts())),
        BlocProvider(
            create: (context) => ProfileBloc()
              ..add(FetchProfileById('b2ecc8ae-9e16-42eb-915f-d2e1e2022f6c'))),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: MyApp(
        initialTheme: initialTheme,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeMode initialTheme;
  const MyApp({super.key, required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/home': (context) => const MyHomePage(),
            '/directMessage': (context) => const DirectMessagePage(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/username': (context) => const PickUsernamePage(),
            '/newPost': (context) => const NewPostPage(),
            '/discover': (context) => const DiscoverPage(),
            '/profile': (context) => const ProfilePage(),
            '/messages': (context) => const MessagesPage(),
          },
          title: 'Motsaich',
          theme: state.lightTheme,
          darkTheme: state.darkTheme,
          themeMode: state.themeMode,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final TabController _tabController;
  final ValueNotifier<bool> isTabBarVisible = ValueNotifier<bool>(true);
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  static List<Map<String, dynamic>> appBarConfigs = [
    {
      'title': 'Mozaik',
      'rightIcon': CupertinoIcons.bell,
      'onRightIconTap': (BuildContext context) {
        _showNotificationsTab(context);
      },
    },
    {
      'leftIcon': Icons.search,
      'rightIcon': Icons.filter_alt_outlined,
      'title': 'Search'
    },
    {
      'title': 'Messages',
      'leftIcon': Icons.menu,
      'rightIcon': FluentIcons.add_24_regular,
    },
    {},
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final appBarConfig = appBarConfigs[selectedIndex];

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppColors.background
          : AppColors.backgroundDark,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.85,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.background
            : AppColors.backgroundDark,
        child: SafeArea(
          child: Column(
            children: [

              // Header Section (with flexible height)
              Container(
                constraints: BoxConstraints(
                  minHeight: 120,
                  maxHeight: MediaQuery.of(context).size.height * 0.25,
                ),
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile row
                    Row(
                      children: [
                        Stack(
                          children: [
                            BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                                if (state is ProfileLoaded) {
                                  return CircleAvatar(
                                    radius: 32,
                                    backgroundImage: CachedNetworkImageProvider(
                                      state.user.profilePic,
                                    ),
                                  );
                                }
                                return const CircleAvatar(
                                  radius: 32,
                                  child: Icon(Icons.person),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, state) {
                                  if (state is ProfileLoaded) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.user.username,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '@${state.user.handle}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return const Text('Loading...');
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.brightness_6,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            context.read<ThemeBloc>().add(ToggleThemeEvent());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('128', 'Following'),
                        _buildStatItem('1.2K', 'Followers'),
                        _buildStatItem('24', 'Posts'),
                      ],
                    ),
                  ],
                ),
              ),

              // Menu Items (now properly constrained)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildDrawerItem(
                      icon: FluentIcons.home_32_filled,
                      label: 'Home',
                      onTap: () => _navigateAndClose(context, '/home'),
                    ),
                    _buildDrawerItem(
                      icon: FluentIcons.person_32_filled,
                      label: 'Profile',
                      onTap: () => _navigateAndClose(context, '/profile'),
                    ),
                    _buildDrawerItem(
                      icon: FluentIcons.bookmark_32_filled,
                      label: 'Saved',
                      badgeCount: 3,
                    ),
                    _buildDrawerItem(
                      icon: FluentIcons.settings_32_filled,
                      label: 'Settings',
                    ),
                    _buildDrawerItem(
                      icon: FluentIcons.add_32_light,
                      label: 'Login',
                      onTap: () => Navigator.pushNamed(context, '/login'),
                    ),
                    const Divider(height: 24),
                    _buildDrawerItem(
                      icon: Icons.help_center,
                      label: 'Help & Feedback',
                    ),
                  ],
                ),
              ),

              // Footer (now outside Expanded)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'App Version 1.0.0',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: _confirmLogout,
                          tooltip: 'Logout',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: selectedIndex != 3
          ? CustomAppBar(
              title: appBarConfig['title'],
              rightWidget: Icon(appBarConfig['rightIcon']),
              onRightWidgetTap: appBarConfig['onRightIconTap'],
              selectedIndex: selectedIndex,
              tabController: _tabController,
              isTabBarVisibleNotifier: isTabBarVisible,
              customWidget: appBarConfig['customWidget'],
            )
          : null,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomePage(),
          const DiscoverPage(),
          const MessagesPage(),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return const ProfilePage();
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        profileIcon: const ProfileIcon(),
      ),
      floatingActionButton: MyFloatingActionButton(
        isVisible: isTabBarVisible.value,
        selectedIndex: selectedIndex,
        isTabBarVisible: isTabBarVisible,
      ),
    );
  }

  static void _showNotificationsTab(BuildContext context) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: kToolbarHeight,
              left: 32,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  elevation: 1,
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.background
                      : AppColors.backgroundDark,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.background
                          : AppColors.backgroundDark,
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.backgroundDark
                            : AppColors.background,
                        width: 0.1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Notifications',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.1,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? AppColors.backgroundDark
                                  : AppColors.background,
                        ),
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 360),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.notifications),
                                  title: Text('Notification $index'),
                                  subtitle: const Text(
                                      'This is a sample notification.'),
                                  onTap: () {},
                                );
                              },
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 0.1,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? AppColors.backgroundDark
                                  : AppColors.background,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                FluentIcons.checkmark_24_regular,
                                size: 26,
                                color: Theme.of(context).primaryColor,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  " Mark all as read",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationsPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "View all",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    int? badgeCount,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Badge(
        isLabelVisible: badgeCount != null,
        label: badgeCount != null ? Text('$badgeCount') : null,
        child: Icon(icon, size: 24),
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _navigateAndClose(BuildContext context, String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle logout
              Navigator.popUntil(ctx, (route) => route.isFirst);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

