import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

var id = '';
class HttpTestRoute extends StatefulWidget {
  String contentId;

  HttpTestRoute({
    Key key,
    @required this.contentId,
  }) : super(key: key);

  @override
  _HttpTestRouteState createState() => new _HttpTestRouteState();
}

class _HttpTestRouteState extends State<HttpTestRoute> {
  String _text = "";
  String title= "title";
  Map <String, dynamic> map;
  @override
  void initState() {
    super.initState();
    getHttpContent().then((val){
      setState(() {
        _text = val['data']['txt'];
        title = val['data']['title'];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: title,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(title),
            ),
            body:  ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width-50.0,
                          // color: Colors.black12,
                          child: Html(
                            data: """
                              ${_text}
                            """,
                            // onImageTap: (src) {
                            //   print(src);
                            // },
                          )
                      )
                    ],
                  ),
                ),
              )
          // home: homeTop.myApp(),
        )
    );

  }


  Future getHttpContent() async {
    try {
      print('http://www.mhxy5kw.com/content/${widget.contentId}');
      Response response = await Dio().get("http://www.mhxy5kw.com/content/${widget.contentId}");
      // _text = json.decode(response.data);
      map = json.decode(response.toString());
      // map = jsonDecode(response.data.toString());
      print(map['data']['title']);

      _text = _text.replaceAll('/u/cms', "http://www.mhxy5kw.com/u/cms");
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
