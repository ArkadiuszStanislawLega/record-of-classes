import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/lists/classes_list_template.dart';
import 'package:record_of_classes/widgets/templates/lists/students_in_group_list_template.dart';

class DetailGroupPage extends StatefulWidget {
  const DetailGroupPage({Key? key}) : super(key: key);

  @override
  _DetailGroupPageState createState() => _DetailGroupPageState();
}

class _DetailGroupPageState extends State<DetailGroupPage> {
  late Group group;
  bool _isEditModeEnabled = false;

  late Store _store;
  late Stream<List<Student>> _studentsStream;

  @override
  Widget build(BuildContext context) {
    group = ModalRoute.of(context)!.settings.arguments as Group;
    group = _store.box<Group>().get(group.id)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text(group.name),
            bottom: const TabBar(
              tabs: [
                Tab(text: Strings.DETAILS),
                Tab(text: '${Strings.LIST} uczestników'),
                Tab(text: '${Strings.LIST} zajęć')
              ],
            ),
          ),
          body: StreamBuilder<List<Student>>(
            stream: _studentsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TabBarView(
                  children: [
                    _isEditModeEnabled
                        ? _editModeEnabled()
                        : _editModeDisabled(),
                    StudentsInGroupListTemplate(group: group),
                    ClassesListTemplate(classesList: group.classes),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
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
    group = _store.box<Group>().get(group.id)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: _setEditModeEnable,
              child: const Text(Strings.EDIT),
            ),
            TextButton(
              onPressed: _navigateToAddStudent,
              child: const Text(Strings.ADD_PARTICIPANTS),
            ),
            TextButton(
              onPressed: _navigateToAddClasses,
              child: const Text(Strings.ADD_CLASSES),
            ),
          ],
        ),
        Text('${Strings.CLASSES_TYPE}: ${group.classesType.target!.name}'),
        Text('${Strings.CLASSES_ADDRESS}: ${group.address.target.toString()}'),
      ],
    );
  }

  void _navigateToAddClasses() =>
      Navigator.pushNamed(context, AppUrls.ADD_CLASSES_TO_GROUP,
          arguments: group);

  void _navigateToAddStudent() =>
      Navigator.pushNamed(context, AppUrls.ADD_STUDENT_TO_GROUP,
          arguments: group);

  void _setEditModeEnable() => setState(() => _isEditModeEnabled = true);

  void _setEditModeDisable() => setState(() => _isEditModeEnabled = false);

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _studentsStream = _store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}