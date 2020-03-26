import 'package:mobilesfa/Omset/omsetcontroller.dart';
import 'Login/signin.dart';
import 'package:mobilesfa/Omset/omset.dart';
import 'UI/dashboardscm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var now = new DateTime.now();
var year = now.year;
var month = now.month < 10 ? '0' + now.month.toString() : now.month.toString();

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title,this.icon);
}

class MyDrawer extends StatefulWidget {
  String name;
  String position;
  String nik;

  MyDrawer({Key key, @required this.name, @required this.position, @required this.nik}) : super(key: key);

  final drawerItem = [
    new DrawerItem("Omset", Icons.show_chart),
    new DrawerItem("Dashboard SCM", Icons.dashboard),
    /*new DrawerItem("Chart", Icons.insert_chart),
    new DrawerItem("Dashboard", Icons.dashboard),
    new DrawerItem("Json", Icons.desktop_windows),
    new DrawerItem("Table", Icons.table_chart),
    new DrawerItem("Setting", Icons.settings),*/
    new DrawerItem("Logout", Icons.exit_to_app),

  ];

  @override
  _MyDrawer createState() => _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {
  int _selectedDrawerIndex = 0;
  String periode = 'O${year}${month}';

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return Omset(nik: widget.nik);
      case 1:
        return DashboardSCM(nik: widget.nik, periode: periode, lokasi: '');
      /*case 2:
        return Dashboard();
      case 3:
        return MyJson();
      case 4:
        return MyTable();
      case 5:
        return MySetting();*/

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItem.length; i++) {
      var d = widget.drawerItem[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title,
              style: TextStyle(fontSize: 18)),
          /*trailing: new Icon(Icons.arrow_right),*/
          selected: i == _selectedDrawerIndex,
          onTap: d.title == 'Logout'
              ? () {
            Default();
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => SignIn()),);
          }
              : () => _onSelectItem(i),
        ),
      );
    }

    return Scaffold(
      appBar: new AppBar(
        title: Center(
          child: new Text(widget.drawerItem[_selectedDrawerIndex].title,
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Logout"),
              ),
            ],
            onSelected: (int value){
              if(value == 1) {
                Default();
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SignIn()));
              }
            },
          ),
        ],
        flexibleSpace: new Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  /*begin: Alignment.topRight,
                  end: Alignment.bottomLeft,*/
                  colors: [Colors.blue, Colors.lightBlueAccent])
          ),
        ),
      ),
      drawer: new Drawer(
        child: SingleChildScrollView(
          child:  new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: Text(widget.name),
                accountEmail: Text(widget.position),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? Colors.blue
                      : Colors.white,
                  child: Text(
                    widget.name.substring(0,1),
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
                /*otherAccountsPictures: <Widget>[
                  CircleAvatar(
                    backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                    child: Text(widget.name.substring(0,1),style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ],*/
              ),
              new Column(children: drawerOptions)
            ],
          ),
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}

/*
import 'package:dashboard/Omset/omset.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Login/loginmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  String name;
  String position;
  String nik;

  MyDrawer({Key key, @required this.name, @required this.position, @required this.nik}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(position),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                name.substring(0,1),
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: BoxDecoration(
              gradient : LinearGradient(colors: <Color>[
                Colors.lightBlueAccent,
                Colors.blue
              ]),
            ),
          ),
//           DrawerHeader(
//             child: Container(
//               child: Column(
//                 children: <Widget>[
//                   Material(
//                     borderRadius: BorderRadius.all(Radius.circular(75.0)),
//                     elevation: 10,
//                     child: Padding(padding: EdgeInsets.all(5.0),
//                     child: Image.asset("images/rocket.png", width: 100, height: 100,),),
//                   ),
//                   Padding(padding: EdgeInsets.all(3.0),
//                     child: Text('User', style: TextStyle(color: Colors.white, fontSize: 20.0),),)
//                 ],
//               ),
//             ),
//             decoration: BoxDecoration(
//               gradient : LinearGradient(colors: <Color>[
//                 Colors.lightBlueAccent,
//                 Colors.blue
//               ]),
//             ),
//           ),
          CustomList(Icons.account_balance_wallet, 'Omset', (){
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/omset', arguments: Omset(nik: nik),
            );
          }),
          CustomList(Icons.person, 'Json', (){
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/json');
          }),
          CustomList(Icons.settings, 'Setting', (){
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/setting');
          }),
          CustomList(Icons.dashboard, 'Chart', (){
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/chart');
          }),
          CustomList(Icons.table_chart, 'Table', (){
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/table');
          }),
          CustomList(Icons.exit_to_app, 'Logout', (){
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/');
          }),
        ],
      ),
    );
  }
}

class CustomList extends StatelessWidget{

  IconData icon;
  String text;
  Function onTap;

  CustomList(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding : const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child : InkWell(
        splashColor: Colors.lightBlue,
        onTap: onTap,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon),
                  Padding(
                    padding : const EdgeInsets.all(8.0),
                    child : Text(text, style: TextStyle(
                      fontSize: 16.0
                  ),),
                  ),
                ],
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}*/