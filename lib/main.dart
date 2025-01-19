import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/bottom_nav_bar.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/pages/discover.dart';
import 'package:mozaik/pages/home.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PageController _pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static const List<Map<String, dynamic>> appBarConfigs = [
    {
      'title': 'Home',
      'leftIcon': FluentIcons.options_24_filled,
      'rightIcon': Icons.notifications,
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
  }

  @override
  Widget build(BuildContext context) {
    final appBarConfig = appBarConfigs[selectedIndex];

    return Scaffold(
      appBar: CustomAppBar(
        title: appBarConfig["title"],
        leftIcon: Icon(appBarConfig["leftIcon"]),
        rightIcon: Icon(appBarConfig["rightIcon"]),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        children: const [
          HomePage(),
          DiscoverPage(),
          MessagesPage(),
          NotificationsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          _pageController.jumpToPage(value);
        },
      ),
    );
  }
}
