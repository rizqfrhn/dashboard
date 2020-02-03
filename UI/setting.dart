import '../Model/setting.dart';
import '../services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MySetting extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MySetting> {
  List<SettingModel> list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get("${url}/GetChannel");
    if (response.statusCode == 200) {
      list = (json.decode(response.body)['Table'] as List)
          .map((data) => new SettingModel.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Data');
    }
  }

 /* @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: new Text("Fetch Data"),
          onPressed: _fetchData,
        ),
      ),
      body: Container(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final x = list[i];
            return ListTile(
              contentPadding: EdgeInsets.all(10.0),
              title: new Text(x.nama_channel),
              subtitle: new Text(x.kode_channel),
            );
          },
        ),
      ),
    );
  }
}