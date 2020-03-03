import '../main.dart';
import '../drawer.dart';
import 'loginmodel.dart';
import '../services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';

class SignIn extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignIn> {
  List<LoginModel> _list = List();
  bool _isLoading = false;
  bool passwordVisible;
  final TextEditingController userController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final FocusNode _userFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    passwordVisible = true;
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
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
              icon: Icon(Icons.highlight_off, color: Colors.red),
              message: 'Username or password was incorrect. Please try again',
              duration: Duration(seconds: 3),
              // Show it with a cascading operator
            )..show(context);
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          Flushbar(
            icon: Icon(Icons.highlight_off, color: Colors.red),
            message: 'Username or password was incorrect. Please try again',
            duration: Duration(seconds: 3),
          )..show(context);
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        Flushbar(
          icon: Icon(Icons.error_outline, color: Colors.red),
          message: 'Oops, something went wrong! Server Error!',
          duration: Duration(seconds: 3),
        )..show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/2.1,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16)
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('images/background6.png'),
                    )
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                    height: 35,
                    child: Text('MOBILE SFA',style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                /*height: MediaQuery.of(context).size.height/1.92,*/
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.all(23),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            controller: userController,
                            focusNode: _userFocus,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(context, _userFocus, _passwordFocus);
                            },
                            style: TextStyle(
                                color: Colors.black,
                            ),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person_outline),
                                labelStyle: TextStyle(
                                    fontSize: 15
                                )
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: passwordVisible,
                          focusNode: _passwordFocus,
                          onFieldSubmitted: (value){
                            _passwordFocus.unfocus();
                          },
                          style: TextStyle(
                              color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            labelStyle: TextStyle(
                                fontSize: 15
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.8,
                        height: 50.0,
                        /*padding: EdgeInsets.symmetric(horizontal: 15.0),*/
                        margin: EdgeInsets.only(top: 50.0),
                        child: RaisedButton(
                          onPressed: userController.text == "" || passwordController.text == "" ? (){
                            setState(() {
                              _isLoading = false;
                              Flushbar(
                                icon: Icon(Icons.highlight_off, color: Colors.red),
                                message: 'Username or Password cannot be blank!',
                                duration: Duration(seconds: 3),
                              )..show(context);
                            });} : () {
                            setState(() {
                              _isLoading = true;
                            });
                            signIn(userController.text, passwordController.text);
                          },//since this is only a UI app
                          child: Text('SIGN IN',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.blue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ),
                      /*Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text('Forgot your password?',
                          style: TextStyle(
                              fontFamily: 'SFUIDisplay',
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      /*Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/background1.png'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter
                  )
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 270),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
                child: Padding(
                padding: EdgeInsets.all(23),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: userController,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person_outline),
                              labelStyle: TextStyle(
                                  fontSize: 15
                              )
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay'
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      margin: EdgeInsets.only(top: 50.0),
                      child: RaisedButton(
                        onPressed: userController.text == "" || passwordController.text == "" ? null : () {
                          setState(() {
                            _isLoading = true;
                          });
                          signIn(userController.text, passwordController.text);
                        },//since this is only a UI app
                        child: Text('SIGN IN',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SFUIDisplay',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.lightBlueAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text('Forgot your password?',
                          style: TextStyle(
                              fontFamily: 'SFUIDisplay',
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),*/
    );
  }
}