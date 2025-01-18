import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/bottom_nav_bar.dart';
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
  int selectedIndex = 0;
  static const List<Widget> pages = <Widget>[
    HomePage(),
    DiscoverPage(),
    MessagesPage(),
    NotificationsPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
