import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/order_model.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_api.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllOrderListShop extends StatefulWidget {
  @override
  _AllOrderListShopState createState() => _AllOrderListShopState();
}

class _AllOrderListShopState extends State<AllOrderListShop> {
  String idShop;
  List<OrderModel> orderModels = List();
  List<List<String>> listNameFoods = List();
  List<List<String>> listPrices = List();
  List<List<String>> listAmounts = List();
  List<List<String>> listSums = List();
  List<int> totals = List();

  @override
  void initState() {
    super.initState();
    findIdShopandReadOreder();
  }

  Future<Null> findIdShopandReadOreder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.getString(ipConstant().keyId);
    print('idShop = $idShop');

    String path =
        '${ipConstant().domain}/gofood/getOrderWhereIdShop.php?isAdd=true&idShop=$idShop';
    await Dio().get(path).then((value) {
      //  print('value => $value');
      var result = json.decode(value.data);

      for (var item in result) {
        OrderModel model = OrderModel.fromJson(item);
        //  print('date = ${model.orderDateTime}');
        List<String> nameFood = MyApi().createStringArray(model.nameFood);
        List<String> prices = MyApi().createStringArray(model.price);
        List<String> amounts = MyApi().createStringArray(model.amount);
        List<String> sums = MyApi().createStringArray(model.sum);

        int total = 0;
        for (var item in sums) {
          total = total + int.parse(item);
        }

        setState(() {
          orderModels.add(model);
          listNameFoods.add(nameFood);
          listPrices.add(prices);
          listAmounts.add(amounts);
          listSums.add(sums);
          totals.add(total);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orderModels.length == 0
          ? my_style().showProgress()
          : ListView.builder(
              itemCount: orderModels.length,
              itemBuilder: (context, index) => Card(
                color: index%2 == 0 ? Colors.lime.shade100 : Colors.lime.shade400,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          my_style().showTitle(orderModels[index].nameUser),
                          my_style().showTitle4(orderModels[index].orderDateTime),
                          buildTitle(),
                          ListView.builder(
                            itemCount: listNameFoods[index].length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index2) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(listNameFoods[index][index2]),
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
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    my_style().showTitle4('Total : '),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child:
                                    my_style().showTitle5(totals[index].toString()),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RaisedButton.icon(
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: () {},
                                icon: Icon(Icons.cancel, color: Colors.white,),
                                label: Text('Cancel', style: TextStyle(color: Colors.white),),
                              ),
                              RaisedButton.icon(
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: () {},
                                icon: Icon(Icons.restaurant, color: Colors.white,),
                                label: Text('Cooking', style: TextStyle(color: Colors.white),),
                              ),
                            ],
                          ),
                        ],
                      ),
                ),
              )),
    );
  }

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.lime.shade700),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Name Food'),
          ),
          Expanded(
            flex: 1,
            child: Text('Price'),
          ),
          Expanded(
            flex: 1,
            child: Text('Amount'),
          ),
          Expanded(
            flex: 1,
            child: Text('Sum'),
          ),
        ],
      ),
    );
  }
}
