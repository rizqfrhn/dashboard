import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

var now = new DateTime.now();
var year = now.year;
var month = now.month < 10 ? '0' + now.month.toString() : now.month.toString();

class DashboardSCM extends StatefulWidget {
  String nik;
  String periode;
  String lokasi;

  DashboardSCM({Key key, @required this.nik, this.periode, this.lokasi}) : super(key: key);

  @override
  _DashboardSCM createState() => new _DashboardSCM();
}

class _DashboardSCM extends State<DashboardSCM> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  String periode = 'O${year}${month}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Chart'),
    ),*/
      body: WebView(
        initialUrl: 'http://14.102.152.197/webdashboard/Dashboard/ServiceLevel/ServiceLevel.aspx?nik=${widget.nik}&periode=${periode}&lokasi=${widget.lokasi}',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      /*WebView(
        initialUrl: 'https://14.102.152.197/webdashboard/Login.aspx',
        javascriptMode: JavascriptMode.unrestricted,
      )*/
    );
  }
}
