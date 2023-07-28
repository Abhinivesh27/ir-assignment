import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ir/service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Container(
            height: 75,
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search Names"
              ),
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            
            stream: Backend.getStudentRecords(),
            builder: (context, snap) {
              if(snap.connectionState == ConnectionState.active || snap.connectionState == ConnectionState.done) {
                  return ListView.builder(
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, index) {
                  return Container(

                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ListTile(
                      title: Text(snap.data!.docs[index]['name']),
                      subtitle:  Text(snap.data!.docs[index]['remark']),
                    ),
                  );
                },
              );
              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
