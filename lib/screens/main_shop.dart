import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/normal_dialog.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:flutter_login/utility/signout_process.dart';
import 'package:flutter_login/widget/information_shop.dart';
import 'package:flutter_login/widget/order_list_shop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login/widget/list_shop.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  String nameUser;
  Widget currentWidget = OrderListShop();

  Future<Null> aboutNotification() async{
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String token = await firebaseMessaging.getToken();
    print('Token ===> $token');

    if(Platform.isAndroid){
        print('Work Android');        
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // RemoteNotification notification = message.notification;
        String titleM = message.notification.title;
        String bodyM = message.notification.body;
        
        print("message recieved : ขณะเปิด App");
        normalDialog2(context, titleM, bodyM);
        
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // RemoteNotification notification = message.notification;
        String titleM2 = message.notification.title;
        String notificM = message.notification.body;

        print('Message clicked! : ขณะปิด App');
        normalDialog2(context, titleM2, notificM);
      
    });
       
    }else if (Platform.isIOS){
       print('Work iOS');
    }
  }


  @override
  void initState() {
    super.initState();
    findUsers();
    aboutNotification();
  }


  Future<Null> findUsers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString("Name");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? "Main Shop" : "$nameUser Login"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => signOutProcess(context))
        ],
      ),
      drawer: showDrawer(),body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(children: <Widget>[
          showHeadDrawer(),
          homeMenu(),
          foodMenu(),
          infoMenu(),
          singOut(),
        ]),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text("รายการอาหารที่สั่ง"),
        subtitle: Text("รายการอาหารที่ยังไม่ได้ทำ"),
        onTap: (){
          setState(() {
             currentWidget = AllOrderListShop();
          });
           Navigator.pop(context);
        },
      );

  ListTile foodMenu() => ListTile(
        leading: Icon(Icons.fastfood),
        title: Text("รายการอาหาร"),
        subtitle: Text("รายการอาหาร"),
        onTap: () {
          setState(() {
             currentWidget = OrderListShop();
          });
           Navigator.pop(context);
        },
      );

  ListTile infoMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text("รายละเอียดของทางร้าน"),
        subtitle: Text("รายละเอียด"),
        onTap: ()  {
          setState(() {
             currentWidget = InformationShop();
          });
           Navigator.pop(context);
        },
      );

  ListTile singOut() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text("Sing Out"),
        onTap: () => signOutProcess(context),
      );

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
      decoration: my_style().myBoxDecoration('Shop.jpg'),
      currentAccountPicture: my_style().showImage(),
      accountName: Text("$nameUser Login"),
      accountEmail: Text(" "),
    );
  }
}
