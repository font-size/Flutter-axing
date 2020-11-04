// weath widget
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:axing/common/Global.dart' as Global;

class myApp extends StatelessWidget{
  String title = 'weatther';

  WeatherFactory wf = new WeatherFactory(Global.mapKey, language: Language.CHINESE_SIMPLIFIED);
  double lat = 55.0111;
  double lon = 15.0569;
  Map <String, dynamic> map;

  // homeTop(String title);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getWeigth();
    return Container(
      margin: EdgeInsets.only(top: 30.0, right: 25.0, left: 25.0), //容器外填充
      constraints: BoxConstraints.tightFor(height: 200.0), //卡片大小
      decoration: BoxDecoration(//背景装饰
          gradient: RadialGradient( //背景径向渐变
              colors: [Colors.red, Colors.orange],
              center: Alignment.topLeft,
              radius: .98
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [ //卡片阴影
            BoxShadow(
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
                blurRadius: 8.0
            )
          ]
      ),
      // transform: Matrix4.rotationZ(.2), //卡片倾斜变换
      alignment: Alignment.center, //卡片内文字居中
      child: Text( //卡片文字
        title, style: TextStyle(color: Colors.white, fontSize: 40.0),
      ),
    );
  }

  Future getWeigth() async {
    try {
      print("$lat $lon");
      Weather w = await wf.currentWeatherByLocation(lat, lon);
      // map = json.decode(w.toString());
      print(w);
      return w;
    } catch(e) {
      print(e);
    }

  }
}
