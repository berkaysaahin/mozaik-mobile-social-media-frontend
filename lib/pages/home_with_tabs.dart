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
      widget.isTabBarVisibleNotifier.value = false;
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
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
        ValueListenableBuilder<bool>(
          valueListenable: widget.isTabBarVisibleNotifier,
          builder: (context, isVisible, child) {
            return isVisible
                ? TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    overlayColor:
                        const WidgetStatePropertyAll<Color>(Colors.transparent),
                    splashFactory: NoSplash.splashFactory,
                    enableFeedback: false,
                    controller: widget.tabController,
                    indicatorColor: AppColors.battleshipGray,
                    labelColor: Colors.black,
                    labelStyle:
                        Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 17,
                            ),
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: "Home"),
                      Tab(text: "Following"),
                    ],
                  )
                : const SizedBox.shrink();
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
