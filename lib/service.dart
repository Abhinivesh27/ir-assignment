import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ir/model.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
CollectionReference _studentRef = _firebaseFirestore.collection('student');

class Appservice extends ChangeNotifier {
  List<Student> _students = [];

  UnmodifiableListView<Student> get students => UnmodifiableListView(_students);

  void getAllStudents() async {
    var response = await _studentRef.get();

    response.docs.forEach(
      (data) {
        _students.add(
          Student(
            data['name'],
            data['remark'],
          ),
        );
      },
    );
    notifyListeners();
  }
}
