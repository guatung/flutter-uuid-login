import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/checkbox.dart';
import 'package:uuid/loginSuccess.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 記住我的bool
  // 此畫面的bool用來控制按鍵UI
  bool remember = false;

  // 輸入帳密欄的TextFormField
  TextEditingController _account = TextEditingController();
  TextEditingController _password = TextEditingController();

  // 登入資訊
  String deviceName;
  String uuid;

  // 確定btn的bgcolor
  LinearGradient bgColor =
      LinearGradient(colors: [Color(0xFF309EF9), Color(0xFF3DBEF9)]);

  // 模組化輸入框
  Container _input(BuildContext context, String label, bool obscure,
          TextEditingController control) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Container(
            decoration: BoxDecoration(
                color: Color(0x90E5E5E5),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      label,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: TextFormField(
                      obscureText: obscure,
                      controller: control,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  )),
                ],
              ),
            )),
      );

  // 提示框
  Future showlog(context, String label) => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: Text(
              label,
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('確定'))
          ],
        );
      });

  // 按下確定鍵後的執行動作與帳密驗證
  login() async {
    // 先防呆帳密沒輸入
    if (_account.text.isEmpty || _password.text.isEmpty) {
      showlog(context, '請輸入帳號密碼');
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      // 通常是使用dio來做網路請求來登入驗證帳號
      // 但在這邊主要是想記錄model跟uuid的筆記
      // 所以先把dio請求網址拿掉

      // 目前的做法是使用內存帳密做驗證
      Map loginData = {'id': 'kelly', 'pwd': '123'};

      // 產品流程是：取得帳號密碼還有該裝置的UUID，送dio後帳密正確且UUID一致即登入成功
      try {
        // 偵測裝置的平台後，取得裝置UUID
        // 帳密符合後即登入
        Map user = {
          "id": _account.text.trim(), // 避免誤按空格，所以會把帳號這邊的空格去掉
          "pwd": _password.text,
        };

        if (Platform.isAndroid) {
          AndroidDeviceInfo android = await deviceInfo.androidInfo;
          deviceName = android.model; // Android裝置的型號
          uuid = android.androidId; // Android裝置的UUID
        } else if (Platform.isIOS) {
          IosDeviceInfo ios = await deviceInfo.iosInfo;
          deviceName = ios.name; // iOS裝置的型號
          uuid = ios.identifierForVendor; // iOS裝置的UUID

        }
        Map x = {
          "deviceName": deviceName,
          "uuid": uuid,
        };
        if (user['id'] == loginData['id'] && user['pwd'] == loginData['pwd']) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home(x)),
          );
        } else {
          print(user);
          showlog(context, '輸入錯誤');
        }
      } catch (e) {
        print('$e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'assets/banner.png',
                  width: MediaQuery.of(context).size.width,
                )),
            _input(context, '帳號', false, _account),
            _input(context, '密碼', true, _password),
            // 記住我
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: <Widget>[
                  CircularCheckBox(
                    inactiveColor: Colors.grey[300],
                    value: remember,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (bool value) {
                      setState(() {
                        remember = value;
                      });
                    },
                  ),
                  Text(
                    '記住我',
                    style: TextStyle(
                        color: remember ? Colors.blue : Colors.grey,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            FlatButton(
              onPressed: () {
                login();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  gradient: bgColor,
                  color: Colors.blue,
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text(
                      '確定',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class _CustomLoadWidget extends StatefulWidget {
  final String label;
  const _CustomLoadWidget({Key key, this.label}) : super(key: key);
  @override
  __CustomLoadWidgetState createState() => __CustomLoadWidgetState(this.label);
}

class __CustomLoadWidgetState extends State<_CustomLoadWidget>
    with SingleTickerProviderStateMixin {
  final String label;
  __CustomLoadWidgetState(this.label);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            label.contains('成功')
                ? Icon(Icons.check, color: Colors.green, size: 30)
                : Icon(Icons.cancel, color: Colors.grey[600], size: 30),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                label,
              ),
            )
          ],
        ),
      ),
    );
  }
}
