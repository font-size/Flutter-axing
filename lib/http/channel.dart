import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:axing/http/content.dart' as httptest;
import 'package:axing/common/Global.dart' as Global;


class ChannelDetailRoute extends StatefulWidget {
  String channelId;

  ChannelDetailRoute({
    Key key,
    @required this.channelId,
  }) : super(key: key);

  @override
  _ChannelDetailRoute createState() => new _ChannelDetailRoute();
}

class _ChannelDetailRoute extends State<ChannelDetailRoute> {
  String _text = ""; // 描述
  String _title= ""; // 栏目名称
  String _topImg = ""; // 标题图
  String _defaultImg = "https://pcdn.flutterchina.club/imgs/book.png"; // 默认图
  List _list = []; // 稿件list数据
  Map <String, dynamic> map; // 栏目详情map
  Map <String, dynamic> maplist; // 稿件list map
  @override
  void initState() {
    super.initState();
    getHttpContent().then((val){
      setState(() {
        _text = val['data']['description'];
        _text = _text.replaceAll('/u/cms', "http://www.mhxy5kw.com/u/cms");
        _title = val['data']['name'];
        _topImg = val['data']['channelExt']['resourcesSpaceData']?val['data']['channelExt']['resourcesSpaceData']['url'] : _defaultImg;

      });
    });
    getHttpContentList().then((val){
      setState(() {
        _list = val['data'];
      });
    });
  }
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
            body: contentList(list: _list, descriptiton: _text, coverImg: _topImg, title: _title,)
          // home: homeTop.myApp(),
        )
    );
  }

  Future getHttpContent() async {
    try {
      print('${Global.channelDetailApi}?id=${widget.channelId}');
      Response response = await Dio().get("${Global.channelDetailApi}?id=${widget.channelId}");
      // _text = json.decode(response.data);
      maplist = json.decode(response.toString());
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

  Future getHttpContentList() async {
    try {
      print('${Global.contentListApi}?channelId=${widget.channelId}');
      Response response = await Dio().get("${Global.contentListApi}?channelId=${widget.channelId}");
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

class myApp extends StatelessWidget{
  final String channelId;
  Map <String, dynamic> map;

  myApp({
    Key key,
    @required this.channelId,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            body: contentList(list: [
              {'title' : '11', 'id': '11'},
              {'title' : '21', 'id': '21'},
              {'title' : '22', 'id': '22'},
            ])
          // home: homeTop.myApp(),
        )
    );
    // return
  }


}

class channelBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return MaterialApp()
    return Wrap(
      direction: Axis.horizontal,
        // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       channelDetailTop(
        //         coverImg: 'https://pcdn.flutterchina.club/imgs/book.png',
        //         title: '栏目名字',
        //         descriptiton: 'descriptiton'
        //       )
        //       // Text(" I am Jack "),
        //     ]
        // ),
        // channelContentList()
        contentList(list: [
          {'title' : '11111111111111111111111111111111111111111111111111', 'id': '1'},
          {'title' : '222222', 'id': '2'},
          {'title' : '33333', 'id': '3'},
          {'title' : '33333', 'id': '3'},
          {'title' : '33333', 'id': '3'},
          {'title' : '33333', 'id': '3'},
          {'title' : '33333', 'id': '3'},
          {'title' : '33333', 'id': '3'},
          {'title' : '2', 'id': '3'},
          {'title' : '234', 'id': '3'},
          {'title' : 'dsfsdds', 'id': '3'},
          {'title' : '44444444', 'id': '4'}
        ])

      ],
    );
  }
}

class contentList extends StatefulWidget {
  String coverImg = "";
  String title = "title";
  String descriptiton = "";
  List list = [];

  contentList({
    Key key,
    @required this.list,
    this.coverImg,
    this.title,
    this.descriptiton,
  }) : super(key: key);

  @override
  _contentList createState() => new _contentList();
}

class _contentList extends State<contentList> {

  @override
  void initState() {
    super.initState();

  }
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
          shrinkWrap: true,
          // physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          children: [
            channelDetailTop(
                coverImg: widget.coverImg,
                title: widget.title,
                descriptiton: widget.descriptiton
            ),
            for (final item in widget.list)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                    alignment: Alignment.centerLeft, //卡片内文字居中
                    height: 50.0,
                    // margin: EdgeInsets.only(top:10.0, left: 10.0), //容器外填充
                    child:  FlatButton(
                      child: Text(
                        item['title'],
                        style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.push( context,
                            MaterialPageRoute(builder: (context) {
                              return httptest.HttpTestRoute(contentId: item['id'],);
                            }));
                      },
                    )
                ),
              ),
            // _listView(context),
          ]
      ),
    );
  }

}

// class contentList extends StatelessWidget {
//   // final List iconList = [];
//   String coverImg = "";
//   String title = "title";
//   String descriptiton = "";
//   _topImg = _topImg.replaceAll('/u/cms', "http://www.mhxy5kw.com/u/cms");
//   List list = [];
//   contentList({
//     Key key,
//     @required this.list,
//     this.coverImg,
//     this.title,
//     this.descriptiton,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView(
//           shrinkWrap: true,
//           // physics: const AlwaysScrollableScrollPhysics(),
//           padding: const EdgeInsets.all(10.0),
//           children: [
//             channelDetailTop(
//                 coverImg: coverImg,
//                 title: title,
//                 descriptiton: descriptiton
//             ),
//             for (final item in list)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Container(
//                     alignment: Alignment.centerLeft, //卡片内文字居中
//                     height: 50.0,
//                     // margin: EdgeInsets.only(top:10.0, left: 10.0), //容器外填充
//                     child:  FlatButton(
//                       child: Text(
//                         item['title'],
//                         style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
//                       ),
//                       onPressed: () {
//                         Navigator.push( context,
//                             MaterialPageRoute(builder: (context) {
//                               return httptest.HttpTestRoute(contentId: item['id'],);
//                             }));
//                       },
//                     )
//                 ),
//               ),
//             // _listView(context),
//           ]
//       ),
//     );
//   }
//
//   List<Widget> _listView(context){
//     return list.map((f)=>
//         Wrap(
//           alignment: WrapAlignment.start,
//           // direction: Axis.horizontal,
//           children: [
//             // Container(
//             //   height: 30.0,
//             //   margin: EdgeInsets.only(top:10.0, left: 10.0), //容器外填充
//             //   child:  Text('${f['id']}',
//             //       style: TextStyle(color: Colors.black,fontSize: 16)),
//             // ),
//             Container(
//               child: Container(
//                   alignment: Alignment.centerLeft, //卡片内文字居中
//                   height: 50.0,
//                   // margin: EdgeInsets.only(top:10.0, left: 10.0), //容器外填充
//                   child:  FlatButton(
//                     child: Text(
//                       f['title'],
//                       style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
//                     ),
//                     onPressed: () {
//                       print(f['id']);
//                     },
//                   )
//               ),
//             ),
//             Divider(color: Colors.black26,)
//           ],
//         ),
//     ).toList();
//   }
// }

class channelDetailTop extends StatelessWidget{
  String coverImg;
  String title = 'title';
  String descriptiton = 'descriptiton';
  String _defaultImg = "https://pcdn.flutterchina.club/imgs/book.png";

  channelDetailTop({
    Key key,
    @required this.title,
    this.coverImg,
    this.descriptiton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('$coverImg 132132');
    print('$title 33333333333');
    print('$descriptiton 1111111111');
    return Container(
      margin: EdgeInsets.only(top: 20.0, right: 25.0, left: 10.0), //容器外填充
      constraints: BoxConstraints.tightFor(height: 100.0), //卡片大小
      child: Wrap(
        children: [
          if(coverImg != null)
            Image.network(
              coverImg?? _defaultImg,
              // height: 150.0,
              width: 100.0,
              fit: BoxFit.contain
            ),
          Column(
            children: [
              Text(title ?? '',
                style: TextStyle(fontSize: 20),
              ),
              Text(descriptiton  ?? '',
                style: TextStyle(fontSize: 18, color: Colors.black12),
              )
            ],
          )
        ],
      ),
    );
  }
}

class channelContentList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 10.0, right: 25.0, left: 10.0), //容器外填充
      child: contentList(list: [
        {'title' : '11111111111111111111111111111111111111111111111111', 'id': '1'},
        {'title' : '222222', 'id': '2'},
        {'title' : '33333', 'id': '3'},
        {'title' : '33333', 'id': '3'},
        {'title' : '33333', 'id': '3'},
        {'title' : '33333', 'id': '3'},
        {'title' : '33333', 'id': '3'},
        {'title' : '33333', 'id': '3'},
        {'title' : '2', 'id': '3'},
        {'title' : '234', 'id': '3'},
        {'title' : 'dsfsdds', 'id': '3'},
        {'title' : '44444444', 'id': '4'}
      ])
    );
  }
}

