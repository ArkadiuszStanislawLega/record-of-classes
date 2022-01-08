import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/create_group_template.dart';
import 'package:record_of_classes/widgets/templates/group_list_view_template.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late ClassesType _classesType;
  late Store _store;
  late Stream<List<Group>> _groupStream;
  final CreateGroupTemplate _createGroupTemplate = CreateGroupTemplate();

  @override
  Widget build(BuildContext context) {
    _classesType = ModalRoute.of(context)!.settings.arguments as ClassesType;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_classesType.name} - ${Strings.ADD_GROUP}'),
      ),
      body: StreamBuilder<List<Group>>(
        stream: _groupStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                _createGroupTemplate,
                TextButton(
                  onPressed: () {
                    if (_createGroupTemplate.isInputValuesAreValid()) {
                      var group = _createGroupTemplate.getGroup();
                      _classesType.groups.add(group);
                      _store.box<ClassesType>().put(_classesType);
                      _createGroupTemplate.clearFields();
                    }
                  },
                  child: const Text(Strings.ADD_GROUP),
                ),
                GroupListviewTemplate(groups: snapshot.data!),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _groupStream = _store
        .box<Group>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
