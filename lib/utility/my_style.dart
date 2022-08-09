import 'package:flutter/material.dart';
import 'package:flutter_login/screens/show_cart.dart';

class my_style {
  Color darkColor = Colors.blue.shade900;
  Color primayrColor = Colors.green;
  
  TextStyle mainStyle = TextStyle(
       fontSize: 18.0,
       fontWeight: FontWeight.bold,
       color: Colors.red,
  );

Widget iconShowCart(BuildContext context){
    return IconButton(onPressed: () {
      MaterialPageRoute route = MaterialPageRoute(builder: (context) => ShowCart());
      Navigator.push(context, route);
    }, icon: Icon(Icons.add_shopping_cart));
}

  TextStyle mainStyle2 = TextStyle(
       fontSize: 16.0,
       fontWeight: FontWeight.bold,
       color: Colors.green,
  );

  SizedBox mySizeBox() => SizedBox(
        width: 8.0,
        height: 16.0,
      );

  Widget showProgress() {
       return Center(child: CircularProgressIndicator(),);
  }

  BoxDecoration myBoxDecoration(String nameImage) {
    return BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/$nameImage'), fit: BoxFit.cover),
    );
  }

  Widget titleCenter(String strw) {
    return Center(
      child: Text(
        strw,
        style: TextStyle(
          fontSize: 24.0, 
          fontWeight: FontWeight.bold),
      ),
    );
  }

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
      );

Text showTitle2(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal),
      );

Text showTitle4(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
      );

Text showTitle3(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
      );

Text showTitle5(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
      );
    
  Container showImage() {
    return Container(
      width: 120.0,
      child: Image.asset("images/logo.png"),
    );
  }

  my_style();
}
