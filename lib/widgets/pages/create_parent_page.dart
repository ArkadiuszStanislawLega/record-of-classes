import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/widgets/templates/create_parent_template.dart';
import 'package:record_of_classes/widgets/templates/create_phone_template.dart';

class CreateParentPage extends StatelessWidget {
  CreateParentPage({Key? key}) : super(key: key);
  final _createParentTemplate = CreateParentTemplate();
  final _createPhone = CreatePhoneTemplate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('create parent page'),
      ),
      body: Column(
        children: [
          _createParentTemplate,
          _createPhone,
          TextButton(onPressed: createParent, child: Text('Dodaj rodzica'))
        ],
      ),
    );
  }

  void createParent(){
    var parent = _createParentTemplate.getParent();
    var phone = _createPhone.getPhone();
    print(parent.person.target.toString());
    print(phone.toString());
  }
}
