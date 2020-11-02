import 'package:flutter/material.dart';

class Myapp extends StatelessWidget {
  Widget mainbody;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        title: 'channel',
        home: Scaffold(
            appBar: AppBar(
              title: Text('栏目详情'),
            ),
            body: mainbody
          // home: homeTop.myApp(),
        )
    );
  }
}