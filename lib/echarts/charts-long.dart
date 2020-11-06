import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:number_display/number_display.dart';

//
// import 'liquid_script.dart' show liquidScript;
// import 'gl_script.dart' show glScript;
// import 'dark_theme_script.dart' show darkThemeScript;

final display = createDisplay(decimal: 2);

class MyApp extends StatelessWidget {
  List<String> list1;
  List<String> list2;
  List<String> days;

  MyApp(
      {Key key,
      @required this.list1,
      @required this.list2,
      @required this.days})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'five day weather',
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("未来5天天气详情"),
          ),
          body: MyHomePage(list1: list1, list2: list2, days: days)),
    );
  }
}

class MyHomePage extends StatefulWidget {
  List<String> list1;
  List<String> list2;
  List<String> days;

  MyHomePage(
      {Key key,
      @required this.list1,
      @required this.list2,
      @required this.days})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List _data1 = ['0'];
  List _data2 = ['0'];
  List _days = ['0'];

  getData1() async {
    this.setState(() {
      this._data1 = widget.list1;
      this._data2 = widget.list2;
      this._days = widget.days;
      // print(_data1);
      // print(_data2);
      // print(_days);
    });
  }

  @override
  void initState() {
    super.initState();
    this.getData1();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // margin: EdgeInsets.only(left: 20.0), //容器外填充
      child: Container(
        width: 800,
        child: Echarts(
          option: '''
              {
                tooltip: {
                    trigger: 'axis'
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: ${_data2}
                },
                yAxis: {
                   show: false
                },
                series: [
                  {  name: '平均气温',
                    type: 'line',
                    data: ${_data1},
                    itemStyle : { normal: {label : {show: true}}}
                  },
                ],
              }
            ''',
          onMessage: (String message) {
            Map<String, Object> messageAction = jsonDecode(message);
            print(messageAction);
            if (messageAction['type'] == 'select') {
              final item = _data1[messageAction['payload']];
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                    item['name'].toString() + ': ' + display(item['value'])),
                duration: Duration(seconds: 2),
              ));
            }
          },
        ),
      ),
    );
  }
}
