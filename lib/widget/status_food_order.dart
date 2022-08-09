import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/order_model.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

class ShowStatusListOrder extends StatefulWidget {
  @override
  _ShowStatusListOrderState createState() => _ShowStatusListOrderState();
}

class _ShowStatusListOrderState extends State<ShowStatusListOrder> {
  String idUser;
  bool statusOrder = true;
  List<OrderModel> orderModels = List();
  List<List<String>> listMenuFoods = List();
  List<List<String>> listPrices = List();
  List<List<String>> listAmounts = List();
  List<List<String>> listSums = List();
  List<int> totalInts = List();
  List<int> statusInts = List();

  @override
  void initState() {
    super.initState();
    findUser();
  }

  @override
  Widget build(BuildContext context) {
    return statusOrder ? buildNonOrder() : buildContent();
  }

  Widget buildContent() => ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: orderModels.length,
      itemBuilder: (context, index) => Column(
            children: <Widget>[
              my_style().mySizeBox(),
              buildNameShop(index),
              buildDateTimeOrder(index),
              buildDistance(index),
              buildTransport(index),
              buildHead(),
              listVeiwMenuFood(index),
              buildTotal(index),
              my_style().mySizeBox(),
              buildStepIndicator(statusInts[index]),
              my_style().mySizeBox(),
            ],
          ));

  Widget buildStepIndicator(int index) => Column(
        children: [
          StepsIndicator(
            lineLength: 90,
            selectedStep: index,
            nbSteps: 4,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Order'),
              Text('Cooking'),
              Text('Delivery'),
              Text('Finish'),
            ],
          ),
        ],
      );

  Widget buildTotal(int index) => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                my_style().showTitle5('ผลรวมอาหาร '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                my_style().showTitle5(totalInts[index].toString()),
              ],
            ),
          ),
        ],
      );

  ListView listVeiwMenuFood(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listMenuFoods[index].length,
        itemBuilder: (context, index2) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(listMenuFoods[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Text(listPrices[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Text(listAmounts[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Text(listSums[index][index2]),
            ),
          ],
        ),
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: my_style().showTitle3('รายการอาหาร'),
          ),
          Expanded(
            flex: 1,
            child: my_style().showTitle3('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: my_style().showTitle3('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: my_style().showTitle3('รวม'),
          ),
        ],
      ),
    );
  }

  Row buildTransport(int index) {
    return Row(
      children: [
        my_style().showTitle5("ค่าขนส่ง ${orderModels[index].transport} บาท"),
      ],
    );
  }

  Row buildDistance(int index) {
    return Row(
      children: [
        my_style()
            .showTitle5('ระยะทาง ${orderModels[index].distance} กิโลเมตร'),
      ],
    );
  }

  Row buildDateTimeOrder(int index) {
    return Row(
      children: [
        my_style().showTitle4('วันที่ ${orderModels[index].orderDateTime}'),
      ],
    );
  }

  Row buildNameShop(int index) {
    return Row(
      children: [
        my_style().showTitle('${orderModels[index].nameShop}'),
      ],
    );
  }

  Center buildNonOrder() => Center(child: Text("ยังไม่มีการสั่ง Order"));

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idUser = preferences.getString('id');
    //print(idUser);
    readOrderFromIdUser();
  }

  Future<Null> readOrderFromIdUser() async {
    if (idUser != null) {
      String url =
          '${ipConstant().domain}/gofood/getOrderWhereidUser.php?isAdd=true&idUser=$idUser';

      Response response = await Dio().get(url);
      print('response = $response');
      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> menuFoods = changArray(model.nameFood);
          List<String> Prices = changArray(model.price);
          List<String> Amounts = changArray(model.amount);
          List<String> Sums = changArray(model.sum);

          int status = 0;
          switch (model.status) {
            case 'UserOder':
                status = 0;
              break;
            case 'ShopCooking' :
                status = 1;
              break;
            case 'Rider' :
                status = 2;
              break;
            case 'Finish' :
                status = 3;
              break;
            default:
          }

          int total = 0;
          for (var string in Sums) {
            total = total + int.parse(string.trim());
          }

          print('total = $total');
          setState(() {
            statusOrder = false;
            orderModels.add(model);
            listMenuFoods.add(menuFoods);
            listPrices.add(Prices);
            listAmounts.add(Amounts);
            listSums.add(Sums);
            totalInts.add(total);
            statusInts.add(status);
          });
        }
      }
    }
  }

  List<String> changArray(String string) {
    List<String> list = List();
    String myString = string.substring(1, string.length - 1);
    print('myString = $myString');
    list = myString.split(',');
    int index = 0;
    for (var string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }
}
