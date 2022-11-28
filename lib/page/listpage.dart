import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_raflyke5/models/employee.dart';
import 'package:flutter_application_raflyke5/page/addpage.dart';
import 'package:flutter_application_raflyke5/page/editpage.dart';
import 'package:flutter_application_raflyke5/service/firebase_crud.dart';

class Listpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<Listpage> {
  final Stream<QuerySnapshot> CollectionReference =
      FirebasedCrud.readEmployee();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("List of Employee"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.app_registration,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AddPage(),
                ),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: CollectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(e["employee_name"]),
                          subtitle: Container(
                            child: (Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Position : " + e['position'],
                                    style: const TextStyle(fontSize: 14)),
                                Text("Contact Number : " + e['contact_no'],
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            )),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(5.0),
                                primary:
                                    const Color.fromARGB(255, 143, 133, 226),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Edit'),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            EditPage(
                                              employee: Employee(
                                                uid: e.id,
                                                employeename:
                                                    e["employee_name"],
                                                position: e["posiition"],
                                                contactno: e["contact_no"],
                                              ),
                                            )),
                                    (route) => false);
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(5.0),
                                primary:
                                    const Color.fromARGB(255, 143, 133, 226),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Delete'),
                              onPressed: () async {
                                var response =
                                    await FirebasedCrud.deleteEmployee(
                                        docId: e.id);
                                if (response.code != 200) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content:
                                              Text(response.message.toString()),
                                        );
                                      });
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
