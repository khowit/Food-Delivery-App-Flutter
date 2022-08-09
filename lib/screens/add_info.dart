import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/normal_dialog.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  File file;
  String nameShop, address, phone, urlImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Information"),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          my_style().mySizeBox(),
          nameForm(),
          my_style().mySizeBox(),
          addressForm(),
          my_style().mySizeBox(),
          phoneForm(),
          my_style().mySizeBox(),
          groupimage(),
          my_style().mySizeBox(),
          saveButton(),
          Container(
            height: 300.0,
          ),
        ]),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: my_style().primayrColor,
        onPressed: () {
          if (nameShop == null ||
              nameShop.isEmpty ||
              address == null ||
              address.isEmpty ||
              phone == null ||
              phone.isEmpty) {
            normalDialog(context, "กรุณากรอกทุกช่องค่ะ");
          } else if (file == null) {
            normalDialog(context, "กรุณาเลือกรูปภาพด้วยค่ะ");
          } else {
            uploadImage();
          }
        },
        icon: Icon(Icons.save, color: Colors.white),
        label: Text(
          "Save",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> uploadImage() async{
     Random random = Random();
     int i = random.nextInt(1000000);
     String nameImage = "shop$i.jpg";
     String url = '${ipConstant().domain}/gofood/saveFile.php';

     try{
         Map<String, dynamic> map = Map();
         map["file"] = await MultipartFile.fromFile(file.path, filename:nameImage);

         FormData formData = FormData.fromMap(map);
         await Dio().post(url, data: formData).then((value) {
           print("Respone ==>> $value");
           urlImage = '/gofood/Shop/$nameImage';
           print("urlImage = $urlImage");
           editUserShop();
         });

     }catch (e){
       print(e);
     }
  }

  Future<Null> editUserShop() async{
       SharedPreferences preferences = await SharedPreferences.getInstance();
       String id = preferences.getString("id");
       String url = '${ipConstant().domain}/gofood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlImage';

       await Dio().get(url).then((value){
         if (value.toString() == 'true'){
               Navigator.pop(context);
         }else{
               normalDialog(context, "กรุณาลองใหม่อีกครั้ง");
         }
       });
  }

  Row groupimage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        Container(
          width: 200.0,
          child: file == null
              ? Image.asset("images/myimage.png")
              : Image.file(file),
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().getImage(
          source: imageSource, maxHeight: 800.0, maxWidth: 800.0);
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              onChanged: (value) => nameShop = value.trim(),
              decoration: InputDecoration(
                  labelText: "ชื่อร้านค้า",
                  prefixIcon: Icon(Icons.account_box),
                  border: OutlineInputBorder()),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              onChanged: (value) => address = value.trim(),
              decoration: InputDecoration(
                  labelText: "ที่อยู่",
                  prefixIcon: Icon(Icons.house),
                  border: OutlineInputBorder()),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              onChanged: (value) => phone = value.trim(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "เบอร์โทรศัพท์",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder()),
            ),
          ),
        ],
      );
}
