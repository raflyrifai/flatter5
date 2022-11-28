import 'package:flutter/material.dart';
import 'package:flutter_application_raflyke5/page/listpage.dart';
import 'package:flutter_application_raflyke5/service/firebase_crud.dart';

import '../models/employee.dart';

class EditPage extends StatefulWidget {
  final Employee? employee;
  EditPage({this.employee});

  @override
  State<StatefulWidget> createState() {
    return _EditPage();
  }
}

class _EditPage extends State<EditPage> {
  final _employee_name = TextEditingController();
  final _employee_position = TextEditingController();
  final _employee_contact = TextEditingController();
  final _docid = TextEditingController();

  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    _docid.value = TextEditingValue(text: widget.employee!.uid.toString());
    _employee_name.value =
        TextEditingValue(text: widget.employee!.employeename.toString());
    _employee_position.value =
        TextEditingValue(text: widget.employee!.position.toString());
    _employee_contact.value =
        TextEditingValue(text: widget.employee!.contactno.toString());
  }

  @override
  Widget build(BuildContext context) {
    final DocIDField = TextField(
        controller: _docid,
        readOnly: true,
        autofocus: false,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final nameField = TextFormField(
        controller: _employee_name,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final positionField = TextFormField(
        controller: _employee_position,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "position",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final contactField = TextFormField(
        controller: _employee_contact,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Contact Number",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final viewListButton = TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => Listpage(),
            ),
            (route) => false,
          );
        },
        child: const Text('View List of Employee'));

    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_fromKey.currentState!.validate()) {
            var response = await FirebasedCrud.updateEmployee(
                name: _employee_name.text,
                position: _employee_position.text,
                contactno: _employee_contact.text,
                docId: _docid.text);
            if (response.code != 200) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            }
          }
        },
        child: Text(
          "Update",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('FreeCode Spot'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
              key: _fromKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DocIDField,
                    const SizedBox(height: 25.0),
                    nameField,
                    const SizedBox(height: 25.0),
                    positionField,
                    const SizedBox(height: 25.0),
                    contactField,
                    const SizedBox(height: 25.0),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
