import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/create_parent_template.dart';
import 'package:record_of_classes/widgets/templates/create_phone_template.dart';

class CreateParentPage extends StatelessWidget {
  CreateParentPage({Key? key}) : super(key: key);
  late Student _student;
  final Store _store = objectBox.store;
  final _createParentTemplate = CreateParentTemplate();
  final _createPhone = CreatePhoneTemplate();

  @override
  Widget build(BuildContext context) {
    _student = ModalRoute.of(context)!.settings.arguments as Student;

    return Scaffold(
      appBar: AppBar(
        title: Text('${Strings.ADD_PARENT} ${_student.person.target!.surname} ${_student.person.target!.name} '),
      ),
      body: Column(
        children: [
          _createParentTemplate,
          _createPhone,
          TextButton(
              onPressed: () {
                createParent();
                Navigator.pop(context);
              },
              child: const Text(Strings.ADD_PARENT))
        ],
      ),
    );
  }

  void createParent() {
    var person = _createParentTemplate.getParent();
    var parent = Parent()..person.target = person;
    var phone = _createPhone.getPhone();

    parent.children.add(_student);
    parent.phone.add(phone);
    phone.owner.target = person;

    _store.box<Parent>().put(parent);
    _store.box<Phone>().put(phone);
  }
}
