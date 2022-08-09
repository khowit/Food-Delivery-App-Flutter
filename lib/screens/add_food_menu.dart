import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/normal_dialog.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File file;
  String nameFood, price, detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มรายการอาหาร"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showTitleFood("เพิ่มรูปภาพอาหาร"),
            my_style().mySizeBox(),
            groupImage(),
            my_style().mySizeBox(),
            showTitleFood("รายละเอียดอาหาร"),
            my_style().mySizeBox(),
            nameForm(),
            my_style().mySizeBox(),
            priceForm(),
            my_style().mySizeBox(),
            dataForm(),
            saveButton(),
            my_style().mySizeBox(),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          color: my_style().primayrColor,
          onPressed: () {
            if (file == null) {
              normalDialog(context, "กรุณาเลือกรูปภาพด้วยค่ะ");
            } else if (nameFood == null ||
                nameFood.isEmpty ||
                price == null ||
                price.isEmpty ||
                detail == null ||
                detail.isEmpty) {
              normalDialog(context, "กรุณากรอกทุกช่องค่ะ");
            } else {
              uploadFoodandSearch();
            }
          },
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          label: Text("Save", style: TextStyle(color: Colors.white)),
        ));
  }

  Future<Null> uploadFoodandSearch() async {

  String urlUpload = "${ipConstant().domain}/gofood/saveFood.php";
  Random random = Random();
  int i = random.nextInt(1000000);

  String nameFile = "food$i.jpg";
  try{
     Map<String, dynamic> map = Map();
     map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
     FormData formData = FormData.fromMap(map);

     await Dio().post(urlUpload, data: formData).then((value) async{
     String urlPathImage = '/gofood/Food/$nameFile';
     print("urlPathImage = ${ipConstant().domain}$urlPathImage");

     SharedPreferences preferences = await SharedPreferences.getInstance();
     String idShop = preferences.getString("id");
     String urlInsert = '${ipConstant().domain}/gofood/insertFood.php?isAdd=true&idShop=$idShop&NameFood=$nameFood&PathImage=$urlPathImage&Price=$price&Detail=$detail';

     await Dio().get(urlInsert).then((value) => Navigator.pop(context));
     
     });

    }catch (e){
       print(e);
    }

  }

  Widget nameForm() => Container(
      width: 350.0,
      child: TextField(
        onChanged: (value) => nameFood = value.trim(),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.fastfood),
            labelText: "ชื่ออาหาร",
            border: OutlineInputBorder()),
      ));

  Widget priceForm() => Container(
      width: 350.0,
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) => price = value.trim(),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.attach_money),
            labelText: "ราคาอาหาร",
            border: OutlineInputBorder()),
      ));

  Widget dataForm() => Container(
      width: 350.0,
      child: TextField(
        maxLines: 4,
        onChanged: (value) => detail = value.trim(),
        keyboardType: TextInputType.multiline,
        maxLength: 50,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.details),
            labelText: "รายละเอียดอาหาร",
            border: OutlineInputBorder()),
      ));

  Row groupImage() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            width: 250.0,
            height: 250.0,
            child: file == null
                ? Image.asset("images/menufood.png")
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ]);
  }

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

  Row showTitleFood(String str) {
    return Row(
      children: [
        my_style().showTitle(str),
      ],
    );
  }
}
