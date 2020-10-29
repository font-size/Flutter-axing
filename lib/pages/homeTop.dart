// weath widget
import 'package:flutter/material.dart';

class myApp extends StatelessWidget{
  String title = 'weatther';

  // homeTop(String title);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 30.0, right: 25.0, left: 25.0), //容器外填充
      constraints: BoxConstraints.tightFor(height: 250.0), //卡片大小
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
}
