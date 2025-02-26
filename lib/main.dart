import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/bottom_nav_bar.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/components/search_bar.dart';
import 'package:mozaik/pages/direct_message.dart';
import 'package:mozaik/pages/discover.dart';
import 'package:mozaik/pages/home_with_tabs.dart';
import 'package:mozaik/pages/login.dart';
import 'package:mozaik/pages/messages.dart';
import 'package:mozaik/pages/notifications.dart';
import 'package:mozaik/pages/pick_username.dart';
import 'package:mozaik/pages/profile.dart';
import 'package:mozaik/pages/register.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
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
      'rightIcon': Icons.filter_alt,
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
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  // Remove border
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: AppColors.teupeGray,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Home',
                  style: TextStyle(
                    color: AppColors.teupeGray,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  // Navigate to the home screen
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    color: AppColors.teupeGray,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  // Navigate to the settings screen
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                title: const Text(
                  'Login',
                  style: TextStyle(
                    color: AppColors.teupeGray,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  // Handle logout
                  Navigator.pushNamed(context, '/login');
                  // Close the drawer
                },
              ),
              ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.teupeGray,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  // Handle logout
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ],
          ),
        ),
      ),
      appBar: selectedIndex != 3
          ? CustomAppBar(
              title: appBarConfig['title'],
              rightIcon: Icon(appBarConfig['rightIcon']),
              onRightIconTap: appBarConfig['onRightIconTap'],
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
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
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
