import 'loginmodel.dart';
import 'package:dashboard/main.dart';
import '../services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

/*bool isEmail;

String validateEmail(String value) {
  if (value.isEmpty) {
    isEmail = false;
    return 'Please enter NIK.';
  }
  isEmail = true;
  return null;
}

String validatePassword(String value) {
  if (value.isEmpty || isEmail == true) {
    return 'Please enter password.';
  }
  return null;
}*/

class _LoginPageState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nikController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool _isLoading = false;
  List<LoginModel> _list = List();

  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('images/rocket.png'),
      ),
    );

    final email = TextFormField(
      controller: nikController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.account_circle, color: Colors.black54),
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      /*validator: validateEmail,*/
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.lock, color: Colors.black54),
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      /*validator: validatePassword,*/
    );

    final loginButton = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
      height: 79.0,
      margin: EdgeInsets.only(bottom: 80.0),
      /*height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),*/
      child: RaisedButton(
        onPressed: nikController.text == "" || passwordController.text == "" ? null : () {
          setState(() {
            _isLoading = true;
          });
          signIn(nikController.text, passwordController.text);
        },
        elevation: 0.0,
        color: Colors.lightBlueAccent,
        child: Text("Login", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    /*final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            Navigator.of(context).pushNamed(HomePage.tag);
          },
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );*/

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton/*,
                forgotLabel*/
              ],
            ),
          ),
        ),
      ),
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Warning'),
          content: Text('You already logout. Please login again to continue!'),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () { Navigator.pop(c, true); Navigator.of(context).pushNamed('/');}
            ),
          ],
        ),
      ),
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
              '/home', arguments: Home(),
            );
          });
        } else {
          setState(() {
            _isLoading = false;
            showDialog(
                context: context,
                builder: (_) =>
                new AlertDialog(
                  content: new Text('Username or password was incorrect. Please try again'),
                ));
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          showDialog(
              context: context,
              builder: (_) =>
              new AlertDialog(
                content: new Text('Username or password was incorrect. Please try again'),
              ));
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        showDialog(
            context: context,
            builder: (_) =>
            new AlertDialog(
              title: new Text('Warning!'),
              content: new Text('Oops, something went wrong! Server Error!'),
            ));
      });
    }
  }
}
