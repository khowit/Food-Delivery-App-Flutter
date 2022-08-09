import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_login/model/user_model.dart';
import 'package:flutter_login/screens/normal_dialog.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/cart_model.dart';
import 'package:flutter_login/utility/SQLite_helper.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCart extends StatefulWidget {
  //const ShowCart({ Key? key }) : super(key: key);

  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = List();
  int total = 0;
  bool status = true;

  @override
  void initState() {
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLlite().readAllDataFromSQLite();
    print('${object.length}');
    if (object.length != 0) {
      for (var model in object) {
        String sumStr = model.sum;
        int sumInt = int.parse(sumStr);

        setState(() {
          status = false;
          cartModels = object;
          total = total + sumInt;
        });
      }
    } else {
      setState(() {
          status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ตะกร้าของฉัน"),
      ),
      body: status
          ? Center(
              child: my_style().showTitle('ตะกร้าว่างเปล่า'),
            )
          : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildNameShop(),
            buildTitle(),
            buildListFood(),
            Divider(),
            buildTotal(),
            buildClearButton(),
            buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget buildClearButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 150.0,
          child: RaisedButton.icon(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: my_style().primayrColor,
            onPressed: () {
              confirmDeleteAllData();
            },
            icon: Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
            label: Text('ลบทั้งหมด', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget buildOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 150.0,
          child: RaisedButton.icon(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.blue.shade900,
            onPressed: () {
               orderThread();
            },
            icon: Icon(
              Icons.fastfood,
              color: Colors.white,
            ),
            label: Text('Order', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget buildTotal() => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                my_style().showTitle3("Total = "),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: my_style().showTitle3(total.toString()),
          ),
        ],
      );

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              my_style().showTitle("ร้าน ${cartModels[0].nameShop}"),
            ],
          ),
          Row(
            children: [
              my_style()
                  .showTitle4("ระยะทาง = ${cartModels[0].distance} กิโลเมตร"),
            ],
          ),
          Row(
            children: [
              my_style()
                  .showTitle4("ค่าขนส่ง = ${cartModels[0].transport} บาท"),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: my_style().showTitle4('รายการอาหาร'),
          ),
          Expanded(
            flex: 1,
            child: my_style().showTitle4('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: my_style().showTitle3('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: my_style().showTitle4('รวม'),
          ),
          Expanded(
            child: my_style().mySizeBox(),
          ),
        ],
      ),
    );
  }

  Widget buildListFood() => ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: cartModels.length,
      itemBuilder: (context, index) => Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text(cartModels[index].nameFood),
              ),
              Expanded(
                flex: 1,
                child: Text(cartModels[index].price),
              ),
              Expanded(
                flex: 1,
                child: Text(cartModels[index].amount),
              ),
              Expanded(
                flex: 1,
                child: Text(cartModels[index].sum),
              ),
              Expanded(
                  flex: 1,
                  child: IconButton(
                      onPressed: () async {
                        int id = cartModels[index].id;
                        print("Delete in $id");

                        await SQLlite().deleteDataWhereId(id).then((value) {
                          print('Success Delete id = $id');
                          readSQLite();
                        });
                      },
                         icon: Icon(Icons.delete_forever))),
            ],
          ));

  Future<Null> confirmDeleteAllData() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text('คุณต้องการลบรายการอาหารทั้งหมดใช่ไหม?'),
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    color: Colors.green,
                    onPressed: () async{
                      Navigator.pop(context);
                      await SQLlite().deleteAllData().then((value) {
                          readSQLite();
                      });
                    },
                    icon: Icon(Icons.check, color: Colors.white,),
                    label: Text('Confirm',style: TextStyle(color: Colors.white))),
                RaisedButton.icon(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    color: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear,color: Colors.white,),
                    label: Text('Cancel',style: TextStyle(color: Colors.white),)),
                ],),
              ],
            ));
  }

  Future<Null> orderThread() async{
    DateTime datetime = DateTime.now();
    //print('datetime = $datetime');
    String orderDatetime = DateFormat('yyyy-MM-dd HH:mm').format(datetime);

    String idShop = cartModels[0].idShop;
    String nameShop = cartModels[0].nameShop;
    String distance = cartModels[0].distance;
    String transport = cartModels[0].transport;

    List<String> idFoods = List();
    List<String> nameFoods = List();
    List<String> prices = List();
    List<String> amounts = List();
    List<String> sums = List();

    for (var model in cartModels) {
         idFoods.add(model.idFood);
         nameFoods.add(model.nameFood);
         prices.add(model.price);
         amounts.add(model.amount);
         sums.add(model.sum);
    }

    String idFood = idFoods.toString();
    String nameFood = nameFoods.toString();
    String price = prices.toString();
    String amount = amounts.toString();
    String sum = sums.toString();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idUser = preferences.getString('id');
    String nameUser = preferences.getString('Name');

    print('datetime = $orderDatetime, idUser = $idUser, NameUser = $nameUser, idShop = $idShop, nameShop = $nameShop, distance = $distance, transport = $transport');
    print('idFood = $idFood, nameFood = $nameFood, price = $price, amount = $amount, sum = $sum');

    String url = '${ipConstant().domain}/gofood/insertOrder.php?isAdd=true&OrderDateTime=$orderDatetime&idUser=$idUser&NameUser=$nameUser&idShop=$idShop&NameShop=$nameShop&Distance=$distance&Transport=$transport&idFood=$idFood&NameFood=$nameFood&Price=$price&Amount=$amount&Sum=$sum&idRider=none&Status=UserOder';
    await Dio().get(url).then((value) {
            if(value.toString() == 'true'){
                 clearAllSQLite();
                 notificationToShop(idShop);
            }else{
                 normalDialog(context, 'กรุณาลองใหม่อีกครั้ง');
            }
    });
  }

  Future<Null> clearAllSQLite() async{
    Fluttertoast.showToast(msg: "Order Success",  toastLength: Toast.LENGTH_LONG, gravity:  ToastGravity.BOTTOM,  backgroundColor: Colors.black, textColor: Colors.white);
    await SQLlite().deleteAllData().then((value) {
          readSQLite();
    });
  }

  Future<Null> notificationToShop(String idShop) async{
        String urlFindToken = '${ipConstant().domain}/gofood/getUserWhereId.php?isAdd=true&id=$idShop';
        await Dio().get(urlFindToken).then((value) {
        
        var result = json.decode(value.data);
        print('result ==> $result');
        
        for (var json in result) {
             UserModel model = UserModel.fromJson(json);
             String tokenShop = model.token;
             print('TokenShop ==>  $tokenShop');
          
             String title = "มี Order";
             String body = "มีการสั่งอาหารค่ะ";
             String urlSendToken = '${ipConstant().domain}/gofood/apiNotification.php?isAdd=true&token=$tokenShop&title=$title&body=$body';
             
             sendNotificationToShop(urlSendToken);
          }
        });
  }

        Future<Null> sendNotificationToShop(String urlSendToken) async{
              await Dio().get(urlSendToken).then((value) => normalDialog(context, 'ส่ง Order ไปร้านค้า'));
        }
}
