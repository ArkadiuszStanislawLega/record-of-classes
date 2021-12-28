import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';

class CreateStudentPage extends StatelessWidget {
  const CreateStudentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create student page'),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: Strings.NAME,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: Strings.SURNAME,
              ),
            ),
            ElevatedButton(
              onPressed: () {

                Navigator.pop(
                  context,
                );
              },
              child: Text('Utworz studenta'),
            ),
          ],
        ));
  }
}
