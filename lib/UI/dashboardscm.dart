import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashboardSCM extends StatefulWidget {
  @override
  _DashboardSCM createState() => new _DashboardSCM();
}

class _DashboardSCM extends State<DashboardSCM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Chart'),
    ),*/
      body: WebView(
        initialUrl: 'https://google.com',
        javascriptMode: JavascriptMode.unrestricted,
      )
    );
  }
}
