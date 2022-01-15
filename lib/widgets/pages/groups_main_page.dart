import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/lists/all_groups_list_template.dart';

class GroupsMainPage extends StatefulWidget {
  const GroupsMainPage({Key? key}) : super(key: key);

  @override
  _GroupsMainPageState createState() => _GroupsMainPageState();
}

class _GroupsMainPageState extends State<GroupsMainPage> {
  late Store _store;
  late Stream<List<Group>> _groupsStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.GROUPS),
      ),
      body: StreamBuilder<List<Group>>(
        stream: _groupsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text('${Strings.NUMBER_OF_GROUPS}: ${snapshot.data!.length}'),
                  AllGroupsTemplate(groups: snapshot.data!),
                ],
              ),
            );
          }
          else {
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
    _groupsStream = _store
        .box<Group>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
