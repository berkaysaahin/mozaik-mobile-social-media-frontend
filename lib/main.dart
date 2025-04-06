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
      drawer: Drawer(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.background
            : AppColors.backgroundDark,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          0.5,
        ),
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.background
                    : AppColors.backgroundDark,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        if (state is ProfileLoaded) {
                          return CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.ashBlue,
                            child: ClipOval(
                              child: Image.network(
                                state.user.profilePic,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else if (state is ProfileError) {
                          return const Icon(Icons.error);
                        } else {
                          return CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 3,
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (state is ProfileLoaded) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user.username,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    state.user.handle,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w200,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withValues(
                                            alpha: 0.6,
                                          ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (state is ProfileError) {
                              return const Icon(Icons.error);
                            } else {
                              return CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 3,
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.brightness_6),
                          onPressed: () {
                            context.read<ThemeBloc>().add(ToggleThemeEvent());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                thickness: 0.1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                    ),
                    leading: const Icon(
                      FluentIcons.home_32_regular,
                      size: 22,
                    ),
                    title: const Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                    ),
                    leading: const Icon(
                      FluentIcons.settings_32_regular,
                      size: 22,
                    ),
                    title: const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                    ),
                    leading: const Icon(
                      CupertinoIcons.goforward,
                      size: 22,
                    ),
                    title: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            ListTile(
              visualDensity: const VisualDensity(
                horizontal: -4,
              ),
              leading: const Icon(
                CupertinoIcons.gobackward,
                size: 22,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
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
                              const Spacer(),
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
}
