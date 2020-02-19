import 'package:mobilesfa/Omset/omsetarea.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'UI/dashboard.dart';
//import 'Login/loginauth.dart';
import 'Login/signin.dart';
import 'UI/json.dart';
import 'UI/setting.dart';
import 'UI/chart.dart';
import 'UI/table.dart';
import 'Omset/omset.dart';
import 'drawer.dart';
/*import 'UI/omsetarea.dart';*/

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => SignIn()
        );
        break;

      case '/drawer':
      // Validation of correct data type
        final MyDrawer args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => MyDrawer(
            name: args.name,
            position: args.position,
            nik: args.nik,
          ),
        );
        break;

      case '/json':
        return MaterialPageRoute(
            builder: (_) => MyJson()
        );
        break;

      case '/setting':
        return MaterialPageRoute(
            builder: (_) => MySetting()
        );
        break;

      case '/chart':
        return MaterialPageRoute(
            builder: (_) => Chart()
        );
        break;

      case '/table':
        return MaterialPageRoute(
            builder: (_) => MyTable()
        );
        break;

      case '/omset':
      final Omset args = settings.arguments;
      return MaterialPageRoute(
          builder: (_) => Omset(
            nik: args.nik,
          )
      );
      break;

        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Undefined Page'),
        ),
        body: Center(
          child: Text('Undefined Page'),
        ),
      );
    });
  }
}