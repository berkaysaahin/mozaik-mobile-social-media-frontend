import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/pages/following.dart';
import 'package:mozaik/pages/home.dart';

class HomeWithTabs extends StatefulWidget {
  final TabController tabController;
  final ValueNotifier<bool> isTabBarVisibleNotifier;
  const HomeWithTabs({
    super.key,
    required this.tabController,
    required this.isTabBarVisibleNotifier,
  });

  @override
  State<HomeWithTabs> createState() => _HomeWithTabsState();
}

class _HomeWithTabsState extends State<HomeWithTabs> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Scrolling down
      widget.isTabBarVisibleNotifier.value = false;
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // Scrolling up
      widget.isTabBarVisibleNotifier.value = true;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Use ValueListenableBuilder to rebuild the TabBar visibility dynamically
        ValueListenableBuilder<bool>(
          valueListenable: widget.isTabBarVisibleNotifier,
          builder: (context, isVisible, child) {
            return isVisible
                ? TabBar(
                    overlayColor:
                        const WidgetStatePropertyAll<Color>(Colors.transparent),
                    splashFactory: NoSplash.splashFactory,
                    enableFeedback: false,
                    controller: widget.tabController,
                    indicatorColor: AppColors.ashGray,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: "Home"),
                      Tab(text: "Following"),
                    ],
                  )
                : const SizedBox.shrink(); // Placeholder for hidden TabBar
          },
        ),
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            children: [
              HomePage(scrollController: _scrollController),
              FollowingPage(scrollController: _scrollController),
            ],
          ),
        ),
      ],
    );
  }
}
