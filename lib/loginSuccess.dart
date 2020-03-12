import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Map x;
  Home(this.x);
  @override
  _HomeState createState() => _HomeState(this.x);
}

class _HomeState extends State<Home> {
  Map x;
  _HomeState(this.x);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text('${x['deviceName']}'),
      ),
      body: WillPopScope(
        // 這邊回傳false是防止登入後因為手勢或是裝置的返回鍵而回到登入頁
        // 所以這一頁的"回上一頁"功能會鎖起來
        onWillPop: () => Future.value(false),
        child: Center(
          child: Text(
            'The uuid is ${x['uuid']}',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
