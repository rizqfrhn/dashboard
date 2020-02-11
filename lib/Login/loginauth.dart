import 'loginmodel.dart';
import '../main.dart';
import '../drawer.dart';
import '../services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  List<LoginModel> _list = List();
  bool _isLoading = false;
  final TextEditingController nikController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return WillPopScope(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
            children: <Widget>[
              headerSection(),
              textSection(),
              buttonSection(),
            ],
          ),
        ),
      ),
      onWillPop: _alert,
    );
  }

  signIn(String nik, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'nik': nik,
      'password': pass
    };
    /*var jsonResponse = null;*/
    var response = await http.post("${url}/CekLogin?", body: data);
    if(response.statusCode == 200) {
      /*jsonResponse = json.decode(response.body)['Table'];*/
      _list = (json.decode(response.body)['Table'] as List)
          .map((data) => new LoginModel.fromJson(data)).toList();
      if(_list.length != 0) {
        if (_list[0].userid == nik && _list[0].password == pass) {
          setState(() {
            _isLoading = false;
            /*sharedPreferences.setString("token", jsonResponse['token']);*/
            Navigator.of(context).pushReplacementNamed(
              '/drawer', arguments: MyDrawer(name : _list[0].nama_karyawan, position : _list[0].jabatan, nik: _list[0].userid,),
            );
          });
        } else {
          setState(() {
            _isLoading = false;
            Flushbar(
              // There is also a messageText property for when you want to
              // use a Text widget and not just a simple String
              message: 'Username or password was incorrect. Please try again',
              // Even the button can be styled to your heart's content
              /*mainButton: FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {},
            ),*/
              duration: Duration(seconds: 3),
              // Show it with a cascading operator
            )..show(context);
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          Flushbar(
            message: 'Username or password was incorrect. Please try again',
            duration: Duration(seconds: 3),
          )..show(context);
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        Flushbar(
          message: 'Oops, something went wrong! Server Error!',
          duration: Duration(seconds: 3),
        )..show(context);
      });
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: nikController.text == "" || passwordController.text == "" ? null : () {
          setState(() {
            _isLoading = true;
          });
          signIn(nikController.text, passwordController.text);
        },
        elevation: 0.0,
        color: Colors.lightBlueAccent,
        child: Text("Sign In", style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: nikController,
            cursorColor: Colors.black54,

            style: TextStyle(color: Colors.black54),
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.black54),
              hintText: "Username",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
              hintStyle: TextStyle(color: Colors.black54),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.black54,
            obscureText: true,
            style: TextStyle(color: Colors.black54),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.black54),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
              hintStyle: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('images/dashboard.png'),
        ),
      ),
    );
  }

  Future<bool> _alert() {
    // TODO
    Flushbar(
      // There is also a messageText property for when you want to
      // use a Text widget and not just a simple String
      message: 'You already logout. Please login again to continue!',
      duration: Duration(seconds: 3),
      // Show it with a cascading operator
    )..show(context);
  }
}