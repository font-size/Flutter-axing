// lesson list
import 'package:flutter/material.dart';

class myLesson extends StatelessWidget {
  // final List iconList = [];
  final List lessonList = [{
    'name': 'flutter组件大全',
    'id': '1',
    'url':'route1'
    },
    {
      'name': 'flutter介绍',
      'id': '2',
      'url':'route2'
    } ,
    {
      'name': 'Dart基础',
      'id': '3',
      'url':'route3'
    }];
  // final lessonList = {
  //   'flutter组件大全': 'route1',
  //   'flutter介绍': 'route2',
  //   'Dart基础': 'route3',
  // };

  @override
  Widget build(BuildContext context) {
    // 下划线widget预定义以供复用。
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(25.0),
      children: _listView(context),
      // children: <Widget>[
      //   for (var index in lessonList)
      //     const Text('$index')
      //     // _RecipeTile(recipe, savedRecipes.indexOf(recipe))
      //   // const Text('I\'m dedicating every day to you'),
      //   // const Text('Domestic life was never quite my style'),
      //   // const Text('When you smile, you knock me out, I fall apart'),
      //   // const Text('And I thought I was so smart'),
      // ],
    );
  }
  List<Widget> _listView(context){
    return lessonList.map((f)=>
    Container(
      margin: EdgeInsets.only(top: 10.0), //容器外填充
      constraints: BoxConstraints.tightFor(height: 60.0), //卡片大小
      color: Colors.white,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.0), //容器外填充
              child: FlutterLogo(
                size: 30,
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0), //容器外填充
              child: Text(
                f['name'],
                style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                // style: Theme.of(context).textTheme.headline5),
            )
          ],
        )
      )
    ).toList();
  }
}