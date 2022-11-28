import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_raflyke5/models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('Employee');

class FirebasedCrud {
//Create
  static Future<Response> addEmployee({
    required String name,
    required String position,
    required String contactno,
  }) async {
    Response response = Response();
    DocumentReference documentReference = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "employee_name": name,
      "position": position,
      "contact_no": contactno,
    };

    var result = await documentReference.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucesfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

//Read
  static Stream<QuerySnapshot> readEmployee() {
    CollectionReference noteIteCollection = _Collection;
    return noteIteCollection.snapshots();
  }

//Update
  static Future<Response> updateEmployee({
    required String name,
    required String position,
    required String contactno,
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReference = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "employee_name": name,
      "position": position,
      "contact_no": contactno,
    };
    await documentReference.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully update Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

//Delete
  static Future<Response> deleteEmployee({
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReference = _Collection.doc(docId);

    await documentReference.delete().whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully delete Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }
}
