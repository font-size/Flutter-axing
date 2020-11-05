// weath widget
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:axing/common/Global.dart' as Global;
// import 'package:axing/charts/temChart.dart' as temChart;
import 'package:axing/echarts/charts-line.dart' as echarts;
import 'package:axing/echarts/charts-oneline.dart' as decharts;

class myApp extends StatefulWidget {

  myApp({
    Key key,
  }) : super(key: key);

  @override
  _myApp createState() => new _myApp();
}

class _myApp extends State<myApp>{
  String title = 'weatther';

  WeatherFactory wf = new WeatherFactory(Global.mapKey, language: Language.CHINESE_SIMPLIFIED);

  List<Weather> forecast = [];
  List<String> wlist = [];

  double lat = 31.22;
  double lon = 121.46;
  double celsius;
  double maxCel;
  double minCel;
  String weatherDescription;
  String icon;
  String location = "shanghai2";
  String country = "china2";
  double cel = 0;
  String defalutImg = "http://openweathermap.org/img/w/01n.png";

  Map <String, dynamic> map;

  @override
  void initState() {
    super.initState();
    getWeather().then((w){
      this.setState(() {
        celsius = w.temperature.celsius;
        weatherDescription = w.weatherDescription;
        icon = w.weatherIcon;
        maxCel = w.tempMax.celsius;
        minCel = w.tempMin.celsius;
        location = w.areaName;
        country = w.country;
        cel =  w.temperature.celsius;
      });
      print(location);
    });

    getFiveWeather().then((fw){
      this.setState(() {
        print(fw.length);
        for(final item in fw) {
          wlist.add(item.temperature.celsius.toStringAsFixed(1));
          // print(item.temperature.celsius);
        }
      });
      print(location);
    });
  }
  // homeTop(String title);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      margin: EdgeInsets.only(top: 30.0, right: 25.0, left: 25.0), //容器外填充
      constraints: BoxConstraints.tightFor(height: 330.0), //卡片大小
      decoration: BoxDecoration(//背景装饰
          gradient: RadialGradient( //背景径向渐变
              colors: [Colors.white, Colors.white],
              center: Alignment.topLeft,
              radius: .98
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          // boxShadow: [ //卡片阴影
          //   BoxShadow(
          //       color: Colors.grey,
          //       offset: Offset(2.0, 2.0),
          //       blurRadius: 8.0
          //   )
          // ]
      ),
      // transform: Matrix4.rotationZ(.2), //卡片倾斜变换
      alignment: Alignment.center, //卡片内文字居中
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0, left: 20.0), //容器外填充
            child: Row(
              children: [
                Text("$location,", style: TextStyle(color: Colors.black, fontSize: 25.0)),
                Text(country??"",style: TextStyle(color: Colors.black, fontSize: 25.0))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0,left: 10.0), //容器外填充
            alignment: Alignment.centerLeft ,
            child: Row(
              children: [
                Image.network(icon != null ?"http://openweathermap.org/img/w/${icon}.png": defalutImg),
                Text(cel.toStringAsFixed(1)??"", style: TextStyle(color: Colors.black, fontSize: 35.0)),
                Text("°C", style: TextStyle(color: Colors.black, fontSize: 35.0))
              ],
            )
          ),
          // Text(weatherDescription?? "")
          Expanded(
            child:  Container(
              margin: EdgeInsets.only(left: 20.0), //容器外填充
              // child: charts.getChartData() ,
              // child:  echarts.MyHomePage(),
              child:  decharts.MyHomePage(),
            ) ,
          ),

        ],
      )
    );
  }
  Future getFiveWeather() async {
    try {
      print("$lat $lon getFiveWeigth");
      forecast = await wf.fiveDayForecastByLocation(lat, lon);
      // print(forecast[0].);
      return forecast;
    } catch(e) {
      print(e);
    }

  }

  Future getWeather() async {
    try {
      print("$lat $lon getWeigth");
      Weather w = await wf.currentWeatherByLocation(lat, lon);
      // print(w.);
      // map = json.decode(w.toString());
      // double nn = w.;
      // String na = w.country;
      return w;
    } catch(e) {
      print(e);
    }

  }
}
