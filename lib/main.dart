import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/blocs/profile_bloc.dart';
import 'package:mozaik/blocs/user_bloc.dart';
import 'package:mozaik/components/bottom_nav_bar.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/components/floating_action_button.dart';
import 'package:mozaik/components/profile_icon.dart';
import 'package:mozaik/components/search_bar.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/events/profile_event.dart';
import 'package:mozaik/pages/direct_message.dart';
import 'package:mozaik/pages/discover.dart';
import 'package:mozaik/pages/home_with_tabs.dart';
import 'package:mozaik/pages/login.dart';
import 'package:mozaik/pages/messages.dart';
import 'package:mozaik/pages/new_post.dart';
import 'package:mozaik/pages/notifications.dart';
import 'package:mozaik/pages/pick_username.dart';
import 'package:mozaik/pages/profile.dart';
import 'package:mozaik/pages/register.dart';
import 'package:mozaik/states/profile_state.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PostBloc()
            ..add(FetchPosts())
            ..add(const FetchPostsByUser('berkaysahin')),
        ),
        BlocProvider(
          create: (context) => ProfileBloc()
            ..add(FetchProfileById('b2ecc8ae-9e16-42eb-915f-d2e1e2022f6c')),
        ),
        BlocProvider(
          create: (context) => UserBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyLarge: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: 0.5,
          ),
          titleMedium: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          labelMedium: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        primaryColor: AppColors.primary,
        focusColor: AppColors.platinum,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        useMaterial3: true,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.platinum,
          selectionColor: AppColors.platinum,
          selectionHandleColor: AppColors.platinum,
        ),
      ),
      home: const MyHomePage(),
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
      'customWidget': const CustomSearchBar(),
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
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: AppColors.background,
          child: Column(
            children: [
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileLoaded) {
                            return CircleAvatar(
                              radius: 32,
                              backgroundColor: AppColors.ashBlue,
                              child: ClipOval(
                                child: Image.network(
                                  state.user.profilePic,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else if (state is ProfileError) {
                            return const Icon(Icons.error);
                          } else {
                            return const CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 3,
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        height: 32,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              blurRadius: 0,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, state) {
                                  if (state is ProfileLoaded) {
                                    return Text(
                                      state.user.username,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    );
                                  } else if (state is ProfileError) {
                                    return const Icon(Icons.error);
                                  } else {
                                    return const CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 3,
                                    );
                                  }
                                },
                              ),
                              const Icon(
                                CupertinoIcons.chevron_down,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        FluentIcons.home_16_regular,
                        size: 20,
                      ),
                      title: const Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        FluentIcons.settings_16_regular,
                        size: 20,
                      ),
                      title: const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        FluentIcons.signature_20_regular,
                        size: 20,
                      ),
                      title: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
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
                leading: const Icon(
                  FluentIcons.sign_out_20_regular,
                  size: 20,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
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
          HomeWithTabs(
            tabController: _tabController,
            isTabBarVisibleNotifier: isTabBarVisible,
          ),
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
                  color: AppColors.background,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.background,
                      border: Border.all(
                        color: AppColors.platinum,
                        width: 0.6,
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
                        const Divider(
                          height: 0.6,
                          color: AppColors.platinum,
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
                        const Divider(
                          height: 0.6,
                          color: AppColors.platinum,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                FluentIcons.checkmark_24_regular,
                                size: 26,
                                color: AppColors.primary,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  " Mark all as read",
                                  style: TextStyle(
                                    color: AppColors.primary,
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
                                child: const Text(
                                  "View all",
                                  style: TextStyle(
                                    color: AppColors.primary,
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
