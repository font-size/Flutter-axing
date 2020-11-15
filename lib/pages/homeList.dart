// lesson list
import 'package:flutter/material.dart';
import 'package:axing/http/channel.dart' as channelDetail;
import 'package:axing/http/channel2.dart' as channelDetail2;
import 'package:axing/http/webViewContent.dart' as webViewContent;

class myLesson extends StatelessWidget {
  // final List iconList = [];
  final List lessonList = [
    {
      'name': 'Flutter精选文章',
      'id': 2301,
      'coverImg': 'http://www.mhxy5kw.com/u/cms/www/202011/091652449phs.png',
      'webView':'route2'
    } ,
    {
      'name': 'Flutter组件',
      'id': 2304,
      'coverImg': 'http://www.mhxy5kw.com/u/cms/www/202011/0916531611e3.png',
      'webView':'route2'
    } ,
    {
      'name': 'Flutter最新资讯',
      'id': 2303,
      'coverImg': 'http://www.mhxy5kw.com/u/cms/www/202011/09165406ftfq.png',
      'webView':'route2'
    } ,
    {
      'name': '个人文章',
      'id': 2305,
      'coverImg': 'http://www.mhxy5kw.com/u/cms/www/202011/09172411jdtz.jpg',
      'webView':'route2'
    },
    {
      'name': '外部文章',
      'id': 2306,
      'coverImg': 'http://www.mhxy5kw.com/u/cms/www/202011/152029148v21.png',
      'webView':'route2'
    },
    {
      'name': 'webView文章',
      'id': 1,
      'coverImg': 'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2458696988,2288615185&fm=26&gp=0.jpg',
      'webView':'webView'
    }];

  @override
  Widget build(BuildContext context) {
    // 下划线widget预定义以供复用。
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(25.0),
      physics: const NeverScrollableScrollPhysics(),
      children: _listView(context),
    );
  }
  List<Widget> _listView(context){
    return lessonList.map((f)=>
    Container(
      margin: EdgeInsets.only(top: 20.0), //容器外填充
      constraints: BoxConstraints.tightFor(height: 70.0), //卡片大小
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.0), //容器外填充
              child: Image.network(
                f['coverImg'],
                width: 50,
                fit: BoxFit.fill,
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0), //容器外填充
              child: FlatButton(
                child: Text(
                  f['name'],
                  style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  //导航到新路由
                  if(f['webView'] == 'webView') {
                    Navigator.push( context,
                        MaterialPageRoute(builder: (context) {
                          return webViewContent.HttpTestRoute(   webViewContentUrl: 'http://www.lichengblog.com/kpc1j/275.jhtml');
                        }));
                  } else {
                    Navigator.push( context,
                        MaterialPageRoute(builder: (context) {
                          return channelDetail2.ChannelDetailRoute(channelId: f['id'],);
                        }));
                  }
                },
              //   // style: Theme.of(context).textTheme.headline5),
            )
           )
          ],
        )
      )
    ).toList();
  }
}