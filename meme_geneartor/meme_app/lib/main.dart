import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MemePage(),
    );
  }
}

class MemePage extends StatefulWidget {
  const MemePage({super.key});

  @override
  State<MemePage> createState() => _MemePageState();
}

class _MemePageState extends State<MemePage> {
  
  Map<String,dynamic> data={};
 
 Future getdatda() async{
  try{
http.Response resp= await http.get(Uri.parse("https://api.imgflip.com/get_memes"));
 data = jsonDecode(resp.body);
return data;



  }
  catch(e){

  }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatda();
    
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(title: Text("Meme App"),
      centerTitle: true,),
      body:FutureBuilder(
        future: getdatda(),
        builder: (context,snapshot) {
          if(snapshot.data==null || snapshot.connectionState==ConnectionState.waiting){
            return  const Center(child: CircularProgressIndicator(color: Colors.red),);
          }
          return ListView.builder(
          itemCount : snapshot.data['data']['memes'].length,
          
             itemBuilder: (context,index) {
               return Expanded(
                 child: Column(
                   children: [
                    
                   
                     Image.network(snapshot.data['data']['memes'][index]['url'],fit: BoxFit.contain,),
                      const SizedBox(height: 5,),
                      Text(snapshot.data['data']['memes'][index]['name'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                   ],
                 ),
               );
             }
           );
        }
      ) ,
    );
  }
}