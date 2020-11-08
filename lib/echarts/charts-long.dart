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
          body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  WeatherFactory wf =
  new WeatherFactory(Global.mapKey, language: Language.CHINESE_SIMPLIFIED);




  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String>  _weatherList = [];
  List <String>  _LongFiveWeatherTempAvg = ['11', '22'];
  List<String>  _LongFiveWeatherDate = ['11-9', '11-10'];

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
    // this.getFiveWeather().then((w) => {
    //   this.setState(() {
    //     this._weatherList = wdLsit;
    //     this._LongFiveWeatherDate = listDay;
    //     this._LongFiveWeatherTempAvg = LongFiveWeatherTempAvg;
    //   })
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // margin: EdgeInsets.only(left: 20.0), //容器外填充
      child: Container(
        width: 800,
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
      String currentDay;
      int listLength = 0;

      forecast = await wf.fiveDayForecastByLocation(lat, lon);
      // forecast[0].weatherDescription

      for(var i = 0; i <forecast.length; i ++) {
        if(listDay.length > 0) {
          print("${forecast[i].date.month}月${forecast[i].date.day}日");
          if(currentDay != "${forecast[i].date.month}月${forecast[i].date.day}日"){
            listDay.add("${forecast[i].date.month}月${forecast[i].date.day}日");
            List<int> empList= [];
            LongFiveWeatherTemp.add(empList);
            listLength += 1;
            currentDay = "${forecast[i].date.month}月${forecast[i].date.day}日";
            wdLsit.add("${forecast[i].weatherDescription}");
            LongFiveWeatherTemp[listLength].add(forecast[i].temperature.celsius.toInt());
          } else {
            LongFiveWeatherTemp[listLength].add(forecast[i].temperature.celsius.toInt());
          }
        } else {
          // 日期不同就在listDay新增日期，并且LongFiveWeatherTemp长度加1, 新增每日wdLsit天气描述
          // 设置当前日期currentDay
          currentDay = "${forecast[i].date.month}月${forecast[i].date.day}日";
          listDay.add("${forecast[i].date.month}月${forecast[i].date.day}日");
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
  List<String> dateList = [];
  List<String> weatherList = [];

  longEchart({Key key, @required this.dateList, @required this.weatherList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(111);
    print(dateList);
    print(weatherList);
    return Container(
      child: Echarts(
        option: '''
              {
                tooltip: {
                    trigger: 'axis'
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: ${dateList},
                },
                yAxis: {
                   show: false
                },
                series: [
                  {  name: '平均气温',
                    type: 'line',
                    data: ${weatherList},
                    itemStyle : { normal: {label : {show: true}}}
                  },
                ],
              }
            ''',
      onMessage: (String message) {
        Map<String, Object> messageAction = jsonDecode(message);
        print(messageAction);
        if (messageAction['type'] == 'select') {
          // final item = weatherList[messageAction['payload']];
          //   _scaffoldKey.currentState.showSnackBar(SnackBar(
          //   content: Text(
          //       item['name'].toString() + ': ' + display(item['value'])),
          //   duration: Duration(seconds: 2),
          // ));
        }
      },
    ),
    );
  }
}
