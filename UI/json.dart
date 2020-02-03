import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/json.dart';

Future<List<JsonModel>> fetchPhotos(http.Client client) async {
  final response =
  await client.get('https://jsonplaceholder.typicode.com/photos');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<JsonModel> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<JsonModel>((json) => JsonModel.fromJson(json)).toList();
}

class MyJson extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<JsonModel>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? JsonList(list: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class JsonList extends StatelessWidget {
  final List<JsonModel> list;

  JsonList({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Image.network(list[index].thumbnailUrl);
      },
    );
  }
}