import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/group.dart';

class DetailGroupPage extends StatefulWidget {
  const DetailGroupPage({Key? key}) : super(key: key);

  @override
  _DetailGroupPageState createState() => _DetailGroupPageState();
}

class _DetailGroupPageState extends State<DetailGroupPage> {
  late Group group;
  bool _isEditModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    group = ModalRoute.of(context)!.settings.arguments as Group;
    return Scaffold(
        appBar: AppBar(
          title: Text(group.name),
        ),
        body: _isEditModeEnabled ? _editModeEnabled() : _editModeDisabled());
  }

  Widget _editModeEnabled() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {
                  _setEditModeDisable();
                },
                child: const Text(Strings.OK)),
            TextButton(
                onPressed: () {
                  _setEditModeDisable();
                },
                child: const Text(Strings.CANCEL))
          ],
        ),
      ],
    );
  }

  Widget _editModeDisabled() {
    return Column(
      children: [
        Text('${Strings.CLASSES_TYPE}: ${group.classesType.target!.name}'),
        Text('${Strings.CLASSES_ADDRESS}: ${group.address.target.toString()}'),
        TextButton(
            onPressed: _setEditModeEnable, child: const Text(Strings.EDIT)),
      ],
    );
  }

  void _setEditModeEnable() => setState(() => _isEditModeEnabled = true);

  void _setEditModeDisable() => setState(() => _isEditModeEnabled = false);
}
