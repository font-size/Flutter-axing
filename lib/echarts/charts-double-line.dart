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

class MyHomePage extends StatefulWidget {
   List<String> list1;
   List<String> list2;

  MyHomePage({Key key,  @required this.list1, @required this.list2}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List  _data1 = [0];
  List  _data2 = [0];

  getData1() async {
    this.setState(() {
      this._data1 = widget.list1;
      this._data2 = widget.list2;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getData1();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      // margin: EdgeInsets.only(left: 20.0), //容器外填充
      child: Echarts(
        option: '''
                    {
                      tooltip: {
                          trigger: 'axis'
                      },
                      xAxis: {
                          type: 'category',
                          boundaryGap: false,
                          data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
                      },
                      yAxis: {
                         show: false
                      },
                      series: [
                        {  name: '最高气温',
                          type: 'line',
                          data: ${_data1},
                          itemStyle : { normal: {label : {show: true}}}
                        },
                        {  name: '最低气温',
                          type: 'line',
                          data: ${_data2},
                          itemStyle : { normal: {label : {show: true}}}
                        }
                      ],
                    }
                  ''',
        onMessage: (String message) {
          Map<String, Object> messageAction = jsonDecode(message);
          print(messageAction);
          if (messageAction['type'] == 'select') {
            final item = _data1[messageAction['payload']];
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(item['name'].toString() + ': ' + display(item['value'])),
                  duration: Duration(seconds: 2),
                ));
          }
        },
      ),
    );
  }
}
