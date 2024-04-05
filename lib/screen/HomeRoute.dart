import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:ultimatedemo/screen/LoginScreen.dart';

class HomeRoute extends StatefulWidget {
  static const String routeName = '/home';
  HomeRoute({super.key});

  double? maxIndex = 4.0;
  LoginScreen loginScreen = LoginScreen();
  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute>  with AutomaticKeepAliveClientMixin {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);
  bool isAuth = false;
  double? _currentIndex = 0.0;

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  /// widget list
  final List<Widget> bottomBarPages = [
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(
      title: '',
    ),
  ];

  @override
  void initState() {
    super.initState();

    bottomBarPages.add(widget.loginScreen);
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
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (_currentIndex != widget.maxIndex && isAuth == false)
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
                  itemLabel: 'Page 1',
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
                  itemLabel: 'Page 2',
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
                  itemLabel: 'Page 3',
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
                  itemLabel: 'Page 4',
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
                /// perform action on tab change and to update pages you can update pages without pages
                log('current selected index $index');
                _pageController.jumpToPage(index);
                setState(() {
                  _currentIndex = _pageController.page;
                });

                log('current selected index ${_currentIndex}');
                print(_currentIndex == widget.maxIndex);
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

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow, child: const Center(child: Text('Page 1')));
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green, child: const Center(child: Text('Page 2')));
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red, child: const Center(child: Text('Page 3')));
  }
}

class Page4 extends StatefulWidget {
  const Page4({super.key, required this.title});

  final String title;

  @override
  State<Page4> createState() => _PageState();
}

class _PageState extends State<Page4>  with AutomaticKeepAliveClientMixin{
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          ElevatedButton(onPressed: _incrementCounter, child: null, )
        ],
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
