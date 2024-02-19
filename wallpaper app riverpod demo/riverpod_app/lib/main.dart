import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

main() {
  runApp(ProviderScope(child: wallpaperApp()));
}

 Future<List> getData() async {
    print("rammm");
    var imgData = await http.get(Uri.parse(
        'https://api.unsplash.com/photos?page=1&client_id=VHFW5Her3S17W9z06s8n7Ll_1Ka8PVbRCeAWHVIKZeo'));

    var jData = jsonDecode(imgData.body);
  
    return jData;

   
  }
final data=FutureProvider<List>((ref) {
  return getData();
});


class wallpaperApp extends ConsumerWidget {

saveimage(String  url) async {
    
  
  var response = await http.get(Uri.parse(url));

    // Get temporary directory
    final dir = await getTemporaryDirectory();

    // Create an image name
    var filename = '${dir.path}/image.png';

    // Save to filesystem
    final file = File(filename);
    await file.writeAsBytes(response.bodyBytes);

    // Ask the user to save it
    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final finalPath = await FlutterFileDialog.saveFile(params: params);


  }
  

  

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final value=ref.watch(data);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("4K HD Wallpaper"),
          centerTitle: true,
          backgroundColor: Colors.amberAccent,
        ),
        body:ref.read(data).when(data: (data){

return GridView.builder(
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index){
              return Column(
                children: [
                  Container(
                    height: 100,
                  
                    padding:  EdgeInsets.all(10),
                    child: Image.network(
                      
                      data[index]['urls']['regular'],
                  
                  
                    ),
                  ),
                  ElevatedButton(onPressed: (){
saveimage(data[index]['urls']['regular']);
                  }, child: Text("Download"))
                ],
              );
            }
        );

        }, error: (error,stacktrace){
          return Text("Got an error");
        }, loading: (){
          return Center(child: CircularProgressIndicator(color: Colors.red,),);
        })
        
         ,
      ),


    );
  }
}