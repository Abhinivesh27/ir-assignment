import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
CollectionReference _studentRef = _firebaseFirestore.collection('student');

class Backend {
 static Stream<QuerySnapshot> getStudentRecords() {
    return _studentRef.get().asStream();
  }
}
