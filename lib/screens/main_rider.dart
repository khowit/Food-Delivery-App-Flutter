import 'package:flutter/material.dart';
import 'package:flutter_login/utility/signout_process.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainRider extends StatefulWidget {
  @override
  _MainRiderState createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {

  String nameUser;

  @override
  void initState() {
    super.initState();
    findUsers();
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
           title: Text(nameUser == null ? "Main Rider" : "$nameUser Login"),
           actions: <Widget>[IconButton(icon: Icon(Icons.exit_to_app), onPressed: () => signOutProcess(context))],
      ),
    );
  }
}