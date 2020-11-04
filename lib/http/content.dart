import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:axing/common/Global.dart' as Global;
import 'package:weather/weather.dart';

class HttpTestRoute extends StatefulWidget {
  int  contentId;

  HttpTestRoute({
    Key key,
    @required this.contentId,
  }) : super(key: key);

  @override
  _HttpTestRouteState createState() => new _HttpTestRouteState();
}

class _HttpTestRouteState extends State<HttpTestRoute> {
  String _text = "";
  String _title= "";
  Map <String, dynamic> map;

  @override
  void initState() {
    super.initState();
    getHttpContent().then((val){
      setState(() {
        _text = val['data']['txt'];
        _text = _text.replaceAll('/u/cms', "http://www.mhxy5kw.com/u/cms");
        _title = val['data']['title'];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'detail',
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("文章详情"),
            ),
            body:  ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width-50.0,
                          // color: Colors.black12,
                          child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10.0), //容器外填充
                                  alignment: Alignment.centerLeft, //卡片内文字居中
                                  // child: Wrap(
                                  //   children: [
                                  //     Text("$_title" * 5, style: TextStyle(color: Colors.black, fontSize: 40.0),)
                                  //   ],
                                  // ),
                                  child:  Text("$_title", style: TextStyle(color: Colors.black, fontSize: 40.0),)
                                ),
                                Container(
                                    // margin: EdgeInsets.only(right: 10.0, left: 10.0), //容器外填充
                                    child: Divider()
                                ),
                                Html(data: """
                                   ${_text} 
                                """),
                              ],
                          ),
                      )
                    ],
                  ),
                ),
              ),
          floatingActionButton: new FloatingActionButton(
          onPressed: () {
            // getWeigth().then((val){
            //   print(val);
            // });
          },
          tooltip: 'up',
          child: new Icon(Icons.arrow_upward),
        ), // This trailing comma makes auto-formatting nicer fo
          // home: homeTop.myApp(),
        )
    );

  }


  Future getHttpContent() async {
    try {
      print('${Global.contentDetailApi}${widget.contentId}');
      Response response = await Dio().get("${Global.contentDetailApi}${widget.contentId}");
      // _text = json.decode(response.data);
      map = json.decode(response.toString());
      // map = jsonDecode(response.data.toString());
      print(_text);
      return map;
    } catch (e) {
      print(e);
    } finally {
      // setState(() {
      //   _loading = false;
      // });
    }
  }

}
