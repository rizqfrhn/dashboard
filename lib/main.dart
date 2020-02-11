import 'package:flutter/material.dart';
import 'UI/dashboard.dart';
import 'drawer.dart';
import 'package:dashboard/routes.dart';

void main() {
  Color darkBlue = Color(0xff071d40);
  runApp(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'QuickSand',
        ),
        // Initially display FirstPage
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      )
    );
}

class Home extends StatelessWidget {
/*  String name;
  String position;
  String nik;

  Home({Key key, @required this.name, @required this.position, @required this.nik}) : super(key: key);*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'),
        /*actions: <Widget>[
          new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Login())
          );}),
        ],*/
      ),
      /*drawer: MyDrawer(name: name, position: position, nik: nik,),*/
      body: Dashboard(),
    );
  }
}