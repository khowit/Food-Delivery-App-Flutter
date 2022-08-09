import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/food_model.dart';
import 'package:flutter_login/screens/normal_dialog.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:image_picker/image_picker.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodModel foodModel;
  EditFoodMenu({Key key, this.foodModel}) : super(key: key);

  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  FoodModel foodModel;
  File file;
  String name, price, detail, pathImage;

  @override
  void initState() {
    super.initState();
    foodModel = widget.foodModel;
    name = foodModel.nameFood;
    price = foodModel.price;
    detail = foodModel.detail;
    pathImage = foodModel.pathImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: uploadButton(),
      appBar: AppBar(
        title: Text("แก้ไขเมนูอาหาร ${foodModel.nameFood}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            gropImage(),
            nameFood(),
            priceFood(),
            detailFood(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(onPressed: () {
        if(name.isEmpty || price.isEmpty || detail.isEmpty){
           normalDialog(context, "กรุณากรอกข้อมูลให้ครบ");
        }else{
            confirmEdit();
        }
      },child: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> confirmEdit() async{
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: my_style().showTitle("คุณต้องการแก้ไขเมนูอาหารใช่ไหม?"),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          editValueOnSQL();
                        },
                        icon: Icon(Icons.check, color: Colors.green,),
                        label: Text("ยืนยัน"),
                    ),
                    FlatButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.clear, color: Colors.red,),
                        label: Text("ยกเลิก"),
                    ),
                  ],
                )
              ],
            )
          );
  }


  Future<Null> editValueOnSQL() async{
     String id = foodModel.id;
     String url2 = '${ipConstant().domain}/gofood/editFoodWhereId.php?isAdd=true&id=$id&NameFood=$name&PathImage=$pathImage&Price=$price&Detail=$detail';
     await Dio().get(url2).then((value){
       if(value.toString() == 'true'){
              Navigator.pop(context);
       }else{
              normalDialog(context, "กรุณาลองใหม่อีกครั้ง !!!");
       }
     });
  }

  Widget gropImage() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(icon: Icon(Icons.add_a_photo), onPressed: () => chooseImage(ImageSource.camera)),
          Container(
            width: 250.0,
            height: 250.0,
            child: file == null ? Image.network('${ipConstant().domain}${foodModel.pathImage}') : Image.file(file),
          ),
          IconButton(icon: Icon(Icons.add_photo_alternate), onPressed: () => chooseImage(ImageSource.gallery))
        ],
      );


  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
            source: source, 
            maxWidth: 800.0, 
            maxHeight: 800.0);

      setState(() {
        file = File(object.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Widget nameFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 320.0,
            child: TextFormField(
              onChanged: (value) => name = value.trim(),
              initialValue: name,
              decoration: InputDecoration(
                labelText: 'ชื่ออาหาร',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget priceFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 320.0,
            child: TextFormField(
              onChanged: (value) => price = value.trim(),
              keyboardType: TextInputType.number,
              initialValue: price,
              decoration: InputDecoration(
                labelText: 'ราคา',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget detailFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 320.0,
            child: TextFormField(
              onChanged: (value) => detail = value.trim(),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              initialValue: detail,
              decoration: InputDecoration(
                labelText: 'รายละเอียด',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
