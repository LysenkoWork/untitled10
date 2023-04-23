import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
//    final String title;
//    String title = Platform.operatingSystem;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Map<String, String> requestHeaders = {
//    'Content-type': 'application/json',
//    'Accept': 'application/json'
  };

//headers: {'Accept': 'application/json'}

  Future<List<User>> getUserList() async {
    final response = await http.get(Uri.parse('http://science-art.pro/test01.php'));
    print(response);
//    final response = await GetConnect().get('http://science-art.pro/test01.php');
//    final response = await Dio().get('http://science-art.pro/test01.php');
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<User> users = items.map<User>((json) {
      return User.fromJson(json);
    }).toList();
    return users;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    if (kIsWeb) {title = 'Web';} else {title = Platform.operatingSystem;};
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () async {
                if (await _userAddDialog(context) != null) {
                  setState(() {});
                 }
              },
              icon: const Icon(Icons.add_alert),)
        ],
      ),
      body:  Center(
        child: FutureBuilder<List<User>>(
          future: getUserList(),
          builder: (context, snapshot)  {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Text('${snapshot.data?[index].name}'),
              );
              },
            );
          }
        )
     )
    );
  }
}


Future<String?> _userAddDialog(BuildContext context) async {
  final nameController = TextEditingController();
  final passController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add user'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "user name"),
              ),
              TextField(
                controller: passController,
                decoration: const InputDecoration(hintText: "password"),
              ),
            ]
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("back"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () async {
                var response = await http.post(Uri.parse('http://science-art.pro/test04.php'),
                    body: {
                      'name': nameController.text,
                      'pass':passController.text
                    });
                Navigator.pop(context, 'Ok');
              }
            ),
          ],
        );
      });
}