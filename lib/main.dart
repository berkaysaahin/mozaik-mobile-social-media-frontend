import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/bottom_nav_bar.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/pages/discover.dart';
import 'package:mozaik/pages/following.dart';
import 'package:mozaik/pages/home.dart';
import 'package:mozaik/pages/home_with_tabs.dart';
import 'package:mozaik/pages/messages.dart';
import 'package:mozaik/pages/notifications.dart';
import 'package:mozaik/pages/profile.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motsaich',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        primaryColor: AppColors.ashGray,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        useMaterial3: true,
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

  static const List<Map<String, dynamic>> appBarConfigs = [
    {
      'title': 'Home',
      'rightIcon': FluentIcons.more_vertical_24_regular,
    },
    {
      'title': 'Discover',
      'leftIcon': Icons.search,
      'rightIcon': Icons.filter_alt,
    },
    {
      'title': 'Messages',
      'leftIcon': Icons.menu,
      'rightIcon': Icons.search,
    },
    {
      'title': 'Notifications',
      'leftIcon': Icons.menu,
      'rightIcon': Icons.search,
    },
    {
      'title': 'Profile',
      'leftIcon': Icons.settings,
      'rightIcon': Icons.edit,
    },
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
      appBar: CustomAppBar(
        title: appBarConfig['title'],
        rightIcon: Icon(appBarConfig['rightIcon']),
        selectedIndex: selectedIndex,
        tabController: _tabController,
        isTabBarVisibleNotifier: isTabBarVisible,
      ),
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Prevent swipe navigation
        children: [
          HomeWithTabs(
            tabController: _tabController,
            isTabBarVisibleNotifier: isTabBarVisible,
          ),
          const DiscoverPage(),
          const MessagesPage(),
          const NotificationsPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
