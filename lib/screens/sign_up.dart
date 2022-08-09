import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/normal_dialog.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String chooseType, name, users, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: ListView(padding: EdgeInsets.all(30.0), children: <Widget>[
        showMylogo(),
        showAppname(),
        my_style().mySizeBox(),
        my_style().mySizeBox(),
        nameForm(),
        my_style().mySizeBox(),
        userForm(),
        my_style().mySizeBox(),
        passwordForm(),
        my_style().mySizeBox(),
        userRadio(),
        shopRadio(),
        riderRadio(),
        my_style().mySizeBox(),
        registerButton(),
      ]),
    );
  }

  Widget registerButton() => Container(
        width: 350.0,
        child: RaisedButton(
          color: my_style().darkColor,
          onPressed: () {
            print("name = $name, user = $users, password = $password, choosetype = $chooseType");
            if(name == null || name.isEmpty || users == null || password == null){
                print("กรุณากรอกข้อมูล");
                normalDialog(context, "กรุณากรอกข้อมูล");
            }
            else if(chooseType == null || name.isEmpty){
            print("กรุณาเลือกรายการที่ต้องการสมัคร");
            normalDialog(context, "กรุณาเลือกรายการที่ต้องการสมัคร");
            }
            else {
              checkUser(); 
            }
          },
          child: Text(
            "Register",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
  
   Future<Null> checkUser() async{
     var url = '${ipConstant().domain}/gofood/getUserWhereUser.php?isAdd=true&Users=$users';

     try{
            Response response = await Dio().get(url);
            if(response.toString() == "null"){
                 registerThread();
                 print(response.toString());
            }else{
                 normalDialog(context, 'ชื่อ user นี้ $users มีคนใช้แล้ว กรุณาเปลี่ยนชื่อใหม่');
                 print(response.toString());
            }
     }catch (e) {
            print(e);
     }

   }

  Future<Null> registerThread() async{
    String url = '${ipConstant().domain}/gofood/insertData.php?isAdd=true&ChooseType=$chooseType&Name=$name&Users=$users&Password=$password';
 
    try{
       Response response = await Dio().get(url);
       print('res = $response');
    }catch (e) {
       print(e);
    }
 }

  Widget userRadio() => Row(mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 250.0,
        child: Row(
              children: <Widget>[
                Radio(
                  value: "User",
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  "ผู้สั่งอาหาร",
                  style: TextStyle(color: my_style().darkColor),
                )
              ],
            ),
      ),
    ],
  );

  Widget shopRadio() => Row(mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 250.0,
        child: Row(
              children: <Widget>[
                Radio(
                  value: "Shop",
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  "เจ้าของร้าน",
                  style: TextStyle(color: my_style().darkColor),
                )
              ],
            ),
      ),
    ],
  );

  Widget riderRadio() => Row(mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 250.0,
        child: Row(
              children: <Widget>[
                Radio(
                  value: "Rider",
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  "คนส่งอาหาร",
                  style: TextStyle(color: my_style().darkColor),
                )
              ],
            ),
      ),
    ],
  );

  Row showAppname() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        my_style().showTitle("GO FOOD"),
      ],
    );
  }

  Widget showMylogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          my_style().showImage(),
        ],
      );

  Widget nameForm() => Container(
      width: 250.0,
      child: TextField(onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.face,
              color: my_style().darkColor,
            ),
            labelStyle: TextStyle(color: my_style().darkColor),
            labelText: 'Name ',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: my_style().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: my_style().primayrColor))),
      ));

  Widget userForm() => Container(
      width: 250.0,
      child: TextField(onChanged: (value) => users = value.trim(),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: my_style().darkColor,
            ),
            labelStyle: TextStyle(color: my_style().darkColor),
            labelText: 'User ',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: my_style().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: my_style().primayrColor))),
      ));

  Widget passwordForm() => Container(
      width: 250.0,
      child: TextField(onChanged: (value) => password = value.trim(),
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: my_style().darkColor,
            ),
            labelStyle: TextStyle(color: my_style().darkColor),
            labelText: 'Password ',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: my_style().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: my_style().primayrColor))),
      ));
}
