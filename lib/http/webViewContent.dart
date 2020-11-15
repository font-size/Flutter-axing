import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:axing/common/Global.dart' as Global;
import 'package:weather/weather.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HttpTestRoute extends StatefulWidget {
  String webViewContentUrl = '';
  HttpTestRoute({
    Key key,
    @required this.webViewContentUrl,
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
    // getHttpContent().then((val){
    //   setState(() {
    //     _text = val['data']['txt'];
    //     _text = _text.replaceAll('/u/cms', "http://www.mhxy5kw.com/u/cms");
    //     _title = val['data']['title'];
    //   });
    // });
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
            child: webView(url: widget.webViewContentUrl),
          ),
          // home: homeTop.myApp(),
        )
    );

  }

  Future getHttpContent() async {
    try {

      // Response response = await Dio().get("${Global.contentDetailApi}${widget.contentId}");
      // _text = json.decode(response.data);
      // map = json.decode(response.toString());
      // map = jsonDecode(response.data.toString());
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

class webView extends StatelessWidget {
  String url = '';

  webView({Key key,   @required this.url}): super(key: key);

  Set<JavascriptChannel> _loadJavascriptChannel(BuildContext context) {
    final Set<JavascriptChannel> channels = Set<JavascriptChannel>();
    JavascriptChannel toastChannel = JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
    channels.add(toastChannel);
    return channels;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: _loadJavascriptChannel(context),
      ),
    );
  }

}
