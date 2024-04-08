import 'package:flutter/material.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key, required this.title});

  final String title;

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> with AutomaticKeepAliveClientMixin {
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