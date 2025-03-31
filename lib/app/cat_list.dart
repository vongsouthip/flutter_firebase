import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/cat_model.dart';
import 'package:http/http.dart' as http;

class CatListScreen extends StatelessWidget {
  const CatListScreen({super.key});

  Future<List<Cat>> fetchCats() async {
    final response = await http.get(
      Uri.parse('https://api.thecatapi.com/v1/images/search?limit=10'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Cat.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load cats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Cat>>(
        future: fetchCats(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 20.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(snapshot.data![index].url),
                  title: Text('Cat ${index + 1}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
