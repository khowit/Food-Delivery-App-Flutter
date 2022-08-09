import 'package:flutter/material.dart';
import 'package:flutter_login/model/user_model.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';

class AboutShop extends StatefulWidget {
  final UserModel userModel;
  AboutShop({Key key, this.userModel}) : super(key: key);

  @override
  _AboutShopState createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              width: 300.0,
              height: 300.0,
              child: Image.network("${ipConstant().domain}${userModel.urlPicture}")),
          ],
        ),ListTile(
            leading: Icon(Icons.home), title: Text(userModel.address),
        ),ListTile(
          leading: Icon(Icons.phone), title: Text(userModel.phone),
        ),ListTile(
          leading: Icon(Icons.directions_bike), title: Text('20 กิโลเมตร'),
        ),ListTile(
          leading: Icon(Icons.transfer_within_a_station), title: Text('20 บาท'),
        ),
      ],
    );
  }
}
