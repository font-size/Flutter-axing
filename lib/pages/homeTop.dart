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
  List<String> wmlist = ['11', '21'];
  List<String> wnlist = ['6', '16'];
  List<String> demolist= ['6', '16','11', '21', '21', '15', '16'];
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

  List<String> LongFiveWeatherDay = [];
  List<String> listDay = [];
  List<List> LongFiveWeatherTemp = [[]];
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
              margin: EdgeInsets.only(top: 20.0, left: 20.0), //容器外填充
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
                          return decharts.MyHomePage(
                              list1: wmlist, list2: wnlist);
                        }
                      } else {
                        return Text("");
                      }
                    },
                  ),
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
                        return lecharts.MyApp(list1: LongFiveWeatherTempAvg, list2: listDay, days: wdLsit);
                      }));
                },
              ),
            ),
          ],
        ));
  }

  Future getFiveWeather() async {
    try {
      print("$lat $lon getFiveWeigth");
      List<String> list1 = [];
      List<String> list2 = [];
      List<String> list3 = [];
      List<String> list4 = [];
      String currentDay;
      List<String> listDay = [];
      List<int> empList= [];
      forecast = await wf.fiveDayForecastByLocation(lat, lon);
      // forecast[0].weatherDescription
      for(final item in forecast) {
        if(list3.length < 7) {
          list3.add(item.temperature.celsius.toStringAsFixed(1));
          list4.add(item.date.hour.toString());
        }
        if(listDay.length > 0) {

          if(currentDay != "${item.date.month}月${item.date.day}日"){
            listDay.add("${item.date.month}月${item.date.day}日");
            LongFiveWeatherTemp.add(empList);
            currentDay = "${item.date.month}月${item.date.day}日";
            wdLsit.add("${item.weatherDescription}");
            LongFiveWeatherTemp[listDay.length - 1].add(item.temperature.celsius.toInt());
          } else {
            LongFiveWeatherTemp[listDay.length - 1].add(item.temperature.celsius.toInt());
          }
        } else {
          currentDay = "${item.date.month}月${item.date.day}日";
          listDay.add("${item.date.month}月${item.date.day}日");
          LongFiveWeatherTemp.add(empList);
          wdLsit.add("${item.weatherDescription}");
        }
      }

      for(var i = 0; i< LongFiveWeatherTemp.length; i++){
        int allTemp = 0;
        for(var l = 0; l > LongFiveWeatherTemp[i].length; l++){
          allTemp += LongFiveWeatherTemp[i][l];
        }
        print(allTemp);
        LongFiveWeatherTempAvg.add((allTemp/LongFiveWeatherTemp[i].length).toStringAsFixed(1));
      }
      print("alltrmp111111");
      this.wmlist = list3;
      this.wnlist = list4;

      return forecast;
    } catch (e) {
      print(e);
    }
  }

  List getwmlist() {
    getFiveWeather().then((fw) {
      print(fw.length);
      for (final item in fw) {
        wmlist.add(item.tempMax.celsius.toStringAsFixed(1));
        // print(item.temperature.celsius);
        return wmlist;
      }
    });
  }

  List getwnlist() {
    getFiveWeather().then((fw) {
      print(fw.length);
      for (final item in fw) {
        wnlist.add(item.tempMin.celsius.toStringAsFixed(1));
        // print(item.temperature.celsius);
      }
      return wnlist;
    });
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
