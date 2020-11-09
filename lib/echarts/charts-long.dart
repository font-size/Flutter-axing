import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:number_display/number_display.dart';
import 'package:weather/weather.dart';
import 'package:axing/common/Global.dart' as Global;
//
// import 'liquid_script.dart' show liquidScript;
// import 'gl_script.dart' show glScript;
// import 'dark_theme_script.dart' show darkThemeScript;

final display = createDisplay(decimal: 2);

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  MyApp(
      {Key key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({
    Key key,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String>  _weatherList = [];
  List <String>  _LongFiveWeatherTempAvg = ['11', '22'];
  List<String>  _LongFiveWeatherDate = ['11-9', '11-10'];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  WeatherFactory wf =
  new WeatherFactory(Global.mapKey, language: Language.CHINESE_SIMPLIFIED);
  double lat = Global.lat;
  double lon = Global.lon;

  List<Weather> forecast = [];
  List<String> LongFiveWeatherDay = [];
  List<List<int>> LongFiveWeatherTemp = [[]];

  List<String> LongFiveWeatherTempAvg = [];
  List<String> wdLsit = [];
  List<String> listDay = [];

  getData1() async {
    this.setState(() {
      // print(_data1);
      // print(_data2);
      // print(_days);
    });
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Echarts Demon'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: FutureBuilder(
          future: getFiveWeather(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // 请求已结束
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // 请求失败，显示错误
                return Text("Error: ${snapshot.error}");
              } else {
                // 请求成功，显示数据
                return longEchart(
                    dateList: _LongFiveWeatherDate, weatherList: _LongFiveWeatherTempAvg);
              }
            } else {
              return Text("");
            }
          },
        ),
      ),
    );

  }

  Future getFiveWeather() async {
      String currentDay = '';
      int listLength = 0;

      forecast = await wf.fiveDayForecastByLocation(lat, lon);
      for(var i = 0; i <forecast.length; i ++) {
        var itemItem = "${forecast[i].date.day}";
        if(listDay.length > 0) {
          if(currentDay != itemItem){
            listDay.add(itemItem);
            List<int> empList= [];
            LongFiveWeatherTemp.add(empList);
            listLength += 1;
            currentDay = itemItem;
            wdLsit.add("${forecast[i].weatherDescription}");
            LongFiveWeatherTemp[listLength].add(forecast[i].temperature.celsius.toInt());
          } else {
            LongFiveWeatherTemp[listLength].add(forecast[i].temperature.celsius.toInt());
          }
        } else {
          // 日期不同就在listDay新增日期，并且LongFiveWeatherTemp长度加1, 新增每日wdLsit天气描述
          // 设置当前日期currentDay
          currentDay = itemItem;
          listDay.add(itemItem);
          // LongFiveWeatherTemp.add(empList);
          wdLsit.add("${forecast[i].weatherDescription}");
        }
      }

      for(var i = 0; i< LongFiveWeatherTemp.length; i++){
        int allTemp = 0;
        // int allTemp = LongFiveWeatherTemp[i].reduce((value, element) => value + element);
        for(var l = 0; l < LongFiveWeatherTemp[i].length; l++){
          allTemp += LongFiveWeatherTemp[i][l];
        }
        LongFiveWeatherTempAvg.add((allTemp/LongFiveWeatherTemp[i].length).toStringAsFixed(1));
        // print(LongFiveWeatherTempAvg);
      }
      _weatherList = wdLsit;
      _LongFiveWeatherDate = listDay;
      _LongFiveWeatherTempAvg = LongFiveWeatherTempAvg;

      return forecast;
  }

}

class longEchart extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> dateList = [];
  List<String> weatherList = [];

  longEchart({Key key, @required this.dateList, @required this.weatherList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("dateList weatherList");
    print(dateList);
    print(weatherList);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 800,
        child: Echarts(
          option: '''
              {
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    axisLabel :{
                       interval: 0,
                       rotate:40  
                    },
                    data: ${dateList},
                },
                yAxis: {
                  type: 'value',
                  boundaryGap: [0, '100%']
                },
                series: [
                  {  name: '平均气温',
                    type: 'line',
                    smooth: true,
                    sampling: 'average',
                    data: ${weatherList},
                   areaStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                            offset: 0,
                            color: 'rgb(255, 158, 68)'
                        }, {
                            offset: 1,
                            color: 'rgb(255, 70, 131)'
                        }])
                    },
                    itemStyle : { normal: {label : {show: true}}}
                  },
                ],
              }
            ''',
          onMessage: (String message) {
            Map<String, Object> messageAction = jsonDecode(message);
            print(messageAction);
            if (messageAction['type'] == 'select') {
              final item = weatherList[messageAction['payload']];
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  // item['name'].toString() + ': ' + display(item['value'])),
                    item.toString() + ': ' + display(9)),
                duration: Duration(seconds: 2),
              ));
            }
          },
        ),
      )
    );
  }
}
