import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:provider/provider.dart';

import 'package:ultimatedemo/screen/UserInfoScreen.dart';

import '../main.dart';
import 'Screen1.dart';
import 'Screen2.dart';
import 'Screen3.dart';
import 'Screen4.dart';

class HomeRoute extends StatefulWidget {
  static const String routeName = '/home';

  HomeRoute();

  double? maxIndex = 4.0;
  //LoginScreen loginScreen = LoginScreen();
  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute>
    with AutomaticKeepAliveClientMixin {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  double? _currentIndex = 0.0;

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);
  late List<Widget> bottomBarPages = [];

  /// widget list

  @override
  void initState() {
    super.initState();
    bottomBarPages.add(
      const Screen1(
        title: '',
      ),
    );
    bottomBarPages.add(
      const Screen2(
        title: '',
      ),
    );
    bottomBarPages.add(
      const Screen3(
        title: '',
      ),
    );
    bottomBarPages.add(
      const Screen4(
        title: '',
      ),
    );
    bottomBarPages.add(
      UserInfoScreen(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (_currentIndex != widget.maxIndex ||
              Provider.of<MyAppState>(context).isAuth == true)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              notchShader: const SweepGradient(
                startAngle: 0,
                endAngle: 3 / 2,
                colors: [
                  Colors.white,
                  Colors.black,
                ],
                tileMode: TileMode.mirror,
              ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
              notchColor: Colors.black87,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,
              elevation: 10,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.black,
                  ),
                  itemLabel: 'Screen 1',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.star,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.star,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Screen 2',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.sailing,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.sailing,
                    color: Color.fromARGB(255, 68, 221, 255),
                  ),
                  itemLabel: 'Screen 3',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.settings,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.settings,
                    color: Colors.pink,
                  ),
                  itemLabel: 'Screen 4',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: Colors.yellow,
                  ),
                  itemLabel: 'LoginScreen',
                ),
              ],
              onTap: (index) {
                _pageController.jumpToPage(index);
                setState(() {
                  _currentIndex = _pageController.page;
                });
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
