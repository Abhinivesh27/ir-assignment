import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ir/model.dart';
import 'package:ir/service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
    return ListenableProvider(
      create: (context) => Appservice(),
      builder: (context, child) {
        return MaterialApp(
          title: 'IR Project',
          home: HomePage(controller: _controller),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String seletedText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Appservice>(context, listen: false).getAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Container(
          height: 75,
          width: MediaQuery.of(context).size.width * 0.4,
          child: TypeAheadField(
            onSuggestionSelected: (data) {
              setState(() {
                seletedText = data.name;
              });
            },
            
            suggestionsCallback: (data) {
              if (data != "") {
                return Provider.of<Appservice>(context, listen: false)
                  .students
                  .where((element) => element.name.toLowerCase().contains(data.toLowerCase()));
              }
              else {
                return [Student("No Items Found!", "")];
              }
            },
            itemBuilder: (context, data) {
              return ListTile(
                title: Text(data.name),
              );
            },
          ),
        ),
      ),
      body: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ...List.generate(
                Provider.of<Appservice>(context, listen: true)
                    .students
                    .where((element) => element.name.contains(seletedText))
                    .length,
                (index) => Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ListTile(
                    title: Text(
                      Provider.of<Appservice>(context, listen: true)
                          .students
                          .where(
                              (element) => element.name.contains(seletedText))
                          .toList()[index]
                          .name,
                    ),
                    subtitle: Text(
                      Provider.of<Appservice>(context, listen: true)
                          .students
                          .where(
                              (element) => element.name.contains(seletedText))
                          .toList()[index]
                          .remark,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
