import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/create_parent_template.dart';
import 'package:record_of_classes/widgets/templates/create_phone_template.dart';
import 'package:record_of_classes/widgets/templates/parent_list_template.dart';

class CreateParentPage extends StatefulWidget {
  const CreateParentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateParentPage();
  }
}

class _CreateParentPage extends State<CreateParentPage> {
  late Student _student;
  final Store _store = objectBox.store;
  final _createParentTemplate = CreateParentTemplate();
  final _createPhone = CreatePhoneTemplate();

  @override
  Widget build(BuildContext context) {
    _student = ModalRoute.of(context)!.settings.arguments as Student;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${Strings.ADD_PARENT} ${_student.person.target!.surname} ${_student.person.target!.name} '),
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
              child: const Text(Strings.ADD_PARENT)),
          ParentListTemplate(),
        ],
      ),
    );
  }

  void createParent() {
    var person = _createParentTemplate.getParent();
    var parent = Parent()..person.target = person;
    var phone = _createPhone.getPhone();

    parent.phone.add(phone);
    parent.person.target = person;
    parent.children.add(_student);
    _student.parents.add(parent);

    _store.box<Student>().put(_student);
  }
}
