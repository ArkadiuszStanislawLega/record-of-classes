import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/widgets/templates/create_parent_template.dart';

class CreateParentPage extends StatelessWidget {
  CreateParentPage({Key? key}) : super(key: key);
  final _createParentTemplate = CreateParentTemplate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('create parent page'),
      ),
      body: Column(
        children: [
          _createParentTemplate,
          TextButton(onPressed: createParent, child: Text('Dodaj rodzica'))
        ],
      ),
    );
  }

  void createParent(){
    var parent = _createParentTemplate.getParent();
    print(parent.person.target.toString());
  }
}
