import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key, required this.title});

  final String title;

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with AutomaticKeepAliveClientMixin {
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
          ElevatedButton(
            onPressed: _incrementCounter,
            child: null,
          )
        ],
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}