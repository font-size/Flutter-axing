import 'package:flutter/material.dart';

class myApp extends StatelessWidget{
  final String channelId;

  myApp({
    Key key,
    @required this.channelId,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        title: Text('栏目详情'),
      ),
      body: channelBody()
      // home: homeTop.myApp(),
    );
  }
}

class channelBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              channelDetailTop(
                coverImg: 'https://pcdn.flutterchina.club/imgs/book.png',
                title: '栏目名字',
                descriptiton: 'descriptiton'
              )
              // Text(" I am Jack "),
            ]
        ),
        channelContentList()
        // Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       Text("111"),
        //       // Text(" I am Jack "),
        //     ]
        // ),
      ],
    );
  }
}

class channelDetailTop extends StatelessWidget{
  String coverImg;
  final String title;
  String descriptiton = 'descriptiton';

  channelDetailTop({
    Key key,
    @required this.title,
    this.coverImg,
    this.descriptiton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(coverImg);
    return Container(
      margin: EdgeInsets.only(top: 20.0, right: 25.0, left: 10.0), //容器外填充
      constraints: BoxConstraints.tightFor(height: 100.0), //卡片大小
      child: Row(
        children: [
          if(coverImg != null)
            Image.network(
              coverImg,
              // height: 150.0,
              width: 100.0,
              fit: BoxFit.contain
            ),
          Column(
            children: [
              Text(title,
                style: TextStyle(fontSize: 20),
              ),
              Text(descriptiton,
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
        {'title' : '11111', 'id': '1'},
        {'title' : '222222', 'id': '2'},
        {'title' : '33333', 'id': '3'},
        {'title' : '44444444', 'id': '4'}
      ])
    );
  }
}

class contentList extends StatelessWidget {
  // final List iconList = [];
  List list = [];
  contentList({
    Key key,
    @required this.list,
}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // 下划线widget预定义以供复用。
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10.0),
      children: _listView(context),
    );
  }
  List<Widget> _listView(context){
    return list.map((f)=>
            Column(
              children: [
                Row(
                  children: [
                    Center(
                      child: Container(
                        height: 30.0,
                        margin: EdgeInsets.only(top:10.0, left: 10.0), //容器外填充
                        child:  Text('${f['id']}',
                            style: TextStyle(color: Colors.black,fontSize: 16)),
                      )
                    ),
                    Center(
                      child: Container(
                          height: 30.0,
                          // margin: EdgeInsets.only(top:10.0, left: 10.0), //容器外填充
                          child:  FlatButton(
                            child: Text(
                              f['title'],
                              style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              print(f['id']);
                              //导航到新路由
                              // Navigator.push( context,
                              //     MaterialPageRoute(builder: (context) {
                              //       // return channelDetail.myApp();
                              //     }));
                            },
                          )
                      ),
                    ),

                  ],
                ),
                Divider(color: Colors.black26,)
              ],
            )
    ).toList();
  }
}