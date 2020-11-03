
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:axing/http/content.dart' as httptest;
import 'package:axing/common/Global.dart' as Global;

class ChannelDetailRoute extends StatelessWidget {
  int channelId;

  ChannelDetailRoute({
    Key key,
    @required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'channel',
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text('栏目详情'),
            ),
            body: channelDetail(channelId: channelId)
            // home: homeTop.myApp(),
            ));
  }
}

class channelDetail extends StatefulWidget {
  int channelId;

  channelDetail({
    Key key,
    this.channelId,
  }) : super(key: key);

  @override
  _channelDetail createState() => new _channelDetail();
}

class _channelDetail extends State<channelDetail> {
  String coverImg;
  String title = 'title';
  String descriptiton = 'descriptiton';
  String _defaultImg = "https://pcdn.flutterchina.club/imgs/book.png";
  List _list = []; // 稿件list数据
  bool hasList = false;
  Widget body = Text('no data');
  Widget nobody = Text('no data');
  Map<String, dynamic> map; // 栏目详情map
  Map <String, dynamic> maplist; // 稿件list map

  @override
  void initState() {
    super.initState();
    getHttpContent().then((val) {
      setState(() {
        descriptiton = val['data']['description'];
        descriptiton =
            descriptiton.replaceAll('/u/cms', "http://www.mhxy5kw.com/u/cms");
        title = val['data']['name'];
        coverImg = val['data']['channelExt']['resourcesSpaceData']['url']
            ?? _defaultImg;
        coverImg =
            coverImg.replaceAll('/u/cms', "http://www.mhxy5kw.com/u/cms");
      });
    });
    getHttpContentList().then((val){
      setState(() {
        hasList = true;
        _list = val['data'];
      });
    });
  }

  Widget build(BuildContext context) {
    if(hasList) {
      Widget body = ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return contentItem(title: _list[index]['title'], id: _list[index]['id']);
          }
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 20.0, right: 25.0, left: 10.0), //容器外填充
      constraints: BoxConstraints.tightFor(height: 100.0), //卡片大小
      child: Column(
          // shrinkWrap: true,
          // physics: const AlwaysScrollableScrollPhysics(),
          // padding: const EdgeInsets.all(10.0),
          children: [
            Row(
              children: [
                if (coverImg != null)
                  Image.network(coverImg ?? _defaultImg,
                      // height: 150.0,
                      width: 100.0,
                      fit: BoxFit.contain),
                Column(
                  children: [
                    Text(
                      title ?? '',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      descriptiton ?? '',
                      style: TextStyle(fontSize: 18, color: Colors.black12),
                    )
                  ],
                )
              ],
            ),
                    // body
            ListView.builder(
                itemCount: _list.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  return contentItem(title: _list[index]['title'], id: _list[index]['id']);
                }
            )
            // hasList?? body,
            // contentItem(title: '111', id: 111,)
            // _listView(context),
          ]),
    );
  }

  Future getHttpContent() async {
    try {
      print('${Global.channelDetailApi}?id=${widget.channelId}');
      Response response =
          await Dio().get("${Global.channelDetailApi}?id=${widget.channelId}");
      // _text = json.decode(response.data);
      map = json.decode(response.toString());
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

  Future getHttpContentList() async {
    try {
      print('${Global.contentListApi}?channelId=${widget.channelId}');
      Response response = await Dio().get("${Global.contentListApi}?channelId=${widget.channelId}");
      // _text = json.decode(response.data);
      maplist = json.decode(response.toString());
      print(maplist['data'][0]['title']);
      // map = jsonDecode(response.data.toString());
      return maplist;
    } catch (e) {
      print(e);
    } finally {
      // setState(() {
      //   _loading = false;
      // });
    }
  }

  Widget getItem () {
    return  ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return contentItem(title: _list[index]['title'], id: _list[index]['id']);
        }
    );
  }
}


class contentItem extends StatelessWidget {
  String title;
  int id ;

  contentItem({
    Key key,
    this.title,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
          alignment: Alignment.centerLeft, //卡片内文字居中
          height: 50.0,
          // margin: EdgeInsets.only(top:10.0, left: 10.0), //容器外填充
          child: FlatButton(
            child: Text(
              title?? '',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return httptest.HttpTestRoute(
                      contentId: id,
                    );
                  }));
            },
          )),
    );
  }
}

