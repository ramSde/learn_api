import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Test',
      home: const TestApi(),
    );
  }
}

class TestApi extends StatefulWidget {
  const TestApi({super.key});

  @override
  State<TestApi> createState() => _TestApiState();
}

class _TestApiState extends State<TestApi> {
  String task = "";
  String tasktype="";
  int requiredpeople=0;
  late http.Response resp;

  Future<void> getData() async {
    try {
      var uri = Uri.https("www.boredapi.com", "/api/activity");
      resp = await  get(uri);
      setState(() {
        Map<String, dynamic> data = jsonDecode(resp.body);
        task = data['activity'];
        tasktype=data['type'];
        requiredpeople=data['participants'];
      });
      print(resp);
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hello")),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Task Type : $tasktype"
                 ,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightBlue),
                ),
                  const SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Text(
                    "Task : $task",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightBlue,
                    overflow: TextOverflow.ellipsis,
                    
                    ),
                  ),
                ),
                  const SizedBox(height: 10),
                Text(
                  "People required ofr task : ${requiredpeople.toString()}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightBlue),
                ),
                
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment:MainAxisAlignment.center ,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        getData();
                      },
                      child: const Text("Change"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
