// weath widget
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:axing/common/Global.dart' as Global;

// import 'package:axing/charts/temChart.dart' as temChart;
// import 'package:axing/echarts/charts-double-line.dart' as decharts;
import 'package:axing/echarts/charts-oneline.dart' as decharts;
import 'package:axing/echarts/charts-long.dart' as lecharts;

class myApp extends StatefulWidget {
  myApp({
    Key key,
  }) : super(key: key);

  @override
  _myApp createState() => new _myApp();
}

class _myApp extends State<myApp> {
  String title = 'weatther';

  WeatherFactory wf =
      new WeatherFactory(Global.mapKey, language: Language.CHINESE_SIMPLIFIED);

  List<Weather> forecast = [];
  List<String> wmlist = ['0', '0'];
  List<String> wnlist = ['6', '16'];
  List<String> demolist= ['6', '16','11', '21', '21', '15', '16'];
  double lat = Global.lat;
  double lon = Global.lon;
  double celsius;
  double maxCel;
  double minCel;
  String weatherDescription;
  String icon;
  String location = "";
  String country = "";
  double cel = 0;
  String defalutImg = "http://openweathermap.org/img/w/01n.png";
  String currentTime = '';

  List<String> LongFiveWeatherDay = [];
  List<String> listDay = [];
  List<List<int>> LongFiveWeatherTemp = [[]];
  List<String> LongFiveWeatherTempAvg = [];
  List<String> wdLsit = [];
  Map<String, dynamic> map;

  @override
  void initState() {
    super.initState();
    getWeather().then((w) {
      this.setState(() {
        celsius = w.temperature.celsius;
        weatherDescription = w.weatherDescription;
        icon = w.weatherIcon;
        maxCel = w.tempMax.celsius;
        minCel = w.tempMin.celsius;
        location = w.areaName;
        country = w.country;
        cel = w.temperature.celsius;
        currentTime = "${w.date.month}月${w.date.day}日${w.date.hour}时";
      });
    });
    getFiveWeather().then((w) {
      List<String> list1 = [];
      List<String> list2= [];
      this.setState(() {
        for(var i = 0; i <w.length; i ++) {
          if(i < 7) {
            list1.add(w[i].temperature.celsius.toStringAsFixed(1));
            list2.add(w[i].date.hour.toString());
          }
        }
        this.wmlist = list1;
        this.wnlist = list2;
      });
    });
  }

  // homeTop(String title);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        margin: EdgeInsets.only(top: 30.0, right: 25.0, left: 25.0),
        //容器外填充
        constraints: BoxConstraints.tightFor(height: 330.0),
        //卡片大小
        decoration: BoxDecoration(
          //背景装饰
          gradient: RadialGradient(
              //背景径向渐变
              colors: [Colors.white, Colors.white],
              center: Alignment.topLeft,
              radius: .98),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        // transform: Matrix4.rotationZ(.2), //卡片倾斜变换
        alignment: Alignment.center,
        //卡片内文字居中
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20.0,left: 20.0), //容器外填充
              child:   Text("$currentTime",
                  style: TextStyle(color: Colors.orange, fontSize: 16.0)),
            ),
            Container(
              margin: EdgeInsets.only( left: 20.0), //容器外填充
              child: Row(
                children: [
                  Text("$location,",
                      style: TextStyle(color: Colors.black, fontSize: 25.0)),
                  Text(country ?? "",
                      style: TextStyle(color: Colors.black, fontSize: 25.0)),

                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20.0, left: 10.0), //容器外填充
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Image.network(icon != null
                        ? "http://openweathermap.org/img/w/${icon}.png"
                        : defalutImg),
                    Text(cel.toStringAsFixed(1) ?? "",
                        style: TextStyle(color: Colors.black, fontSize: 35.0)),
                    Text("°C",
                        style: TextStyle(color: Colors.black, fontSize: 35.0))
                  ],
                )),
            // Text(weatherDescription?? "")
            Expanded(
                child: Container(
                  // margin: EdgeInsets.only(left: 20.0), //容器外填充
                  // child: charts.getChartData() ,
                  // child:  echarts.MyHomePage(),
                  child: decharts.MyHomePage(
                      list1: wmlist, list2: wnlist),
                  // child:  decharts.MyHomePage(list1: wmlist, list2: wnlist),
                ),
            ),
            Align(
              alignment: Alignment.center,
              child: RaisedButton(
                textColor: Colors.lightBlue,
                color: Colors.white,
                elevation: 0,
                child: Text("查看未来5天天气 >"),
                onPressed: () {
                  Navigator.push( context,
                      MaterialPageRoute(builder: (context) {
                        return lecharts.MyHomePage();
                      }));
                },
              ),
            ),
          ],
        ));
  }

  Future getFiveWeather() async {
    forecast = await wf.fiveDayForecastByLocation(lat, lon);
    return forecast;
  }

  Future getWeather() async {
    try {
      print("$lat $lon getWeigth");
      Weather w = await wf.currentWeatherByLocation(lat, lon);
      // map = json.decode(w.toString());
      // double nn = w.;
      // String na = w.country;
      return w;
    } catch (e) {
      print(e);
    }
  }
}
