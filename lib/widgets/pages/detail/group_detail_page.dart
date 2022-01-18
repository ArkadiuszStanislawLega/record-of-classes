import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/list_items/classes_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/list_items/students_in_group_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/lists/classes_list_template.dart';
import 'package:record_of_classes/widgets/templates/lists/students_in_group_list_template.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class DetailGroupPage extends StatefulWidget {
  const DetailGroupPage({Key? key}) : super(key: key);

  @override
  _DetailGroupPageState createState() => _DetailGroupPageState();
}

enum ListOnPage { participants, classes }

class _DetailGroupPageState extends State<DetailGroupPage> {
  late Group group;
  bool _isEditModeEnabled = false;
  ListOnPage _currentListOnPage = ListOnPage.participants;

  late Store _store;
  late Stream<List<Student>> _studentsStream;

  @override
  Widget build(BuildContext context) {
    group = ModalRoute.of(context)!.settings.arguments as Group;
    return StreamBuilder<List<Student>>(
      stream: _studentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          group = _store.box<Group>().get(group.id)!;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  _customAppBar(),
                  _content(),
                ],
              ),
              floatingActionButton: SpeedDial(
                icon: Icons.add,
                backgroundColor: Colors.amber,
                children: [
                  SpeedDialChild(
                      child: const Icon(Icons.person),
                      label: Strings.ADD_PARTICIPANTS,
                      backgroundColor: Colors.amberAccent,
                      onTap: _navigateToAddStudent),
                  SpeedDialChild(
                      child: const Icon(Icons.group),
                      label: Strings.ADD_CLASSES,
                      backgroundColor: Colors.amberAccent,
                      onTap: _navigateToAddClasses),
                  SpeedDialChild(
                      child: const Icon(Icons.edit),
                      label: Strings.EDIT,
                      backgroundColor: Colors.amberAccent,
                      onTap: () {}),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: const Size(0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _pageNavigationButton(
                title: Strings.CLASSES, listOnPage: ListOnPage.classes),
            _pageNavigationButton(
                title: Strings.PARTICIPANTS,
                listOnPage: ListOnPage.participants),
          ],
        ),
      ),
      stretch: true,
      onStretchTrigger: () => Future<void>.value(),
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _propertiesView(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.5),
                  end: Alignment.center,
                  colors: <Color>[Colors.black12, Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DecoratedBox _pageNavigationButton(
      {required String title, required ListOnPage listOnPage}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: _currentListOnPage == listOnPage
                ? Colors.black12
                : Colors.transparent,
            offset: const Offset(0, -1),
            blurRadius: 4,
          )
        ],
      ),
      child: TextButton(
        onPressed: () => setState(() => _currentListOnPage = listOnPage),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  SliverList _content() => _pageNavigator();

  SliverList _pageNavigator() {
    switch (_currentListOnPage) {
      case ListOnPage.classes:
        return _classesSliverList();
      case ListOnPage.participants:
        return _participantsSliverList();
    }
  }

  SliverList _classesSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => ClassesListItemTemplate(
          classes: group.classes.elementAt(index),
        ),
        childCount: group.classes.length,
      ),
    );
  }

  SliverList _participantsSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => StudentsInGroupListItemTemplate(
          group: group,
          student: group.students.elementAt(index),
        ),
        childCount: group.students.length,
      ),
    );
  }

  SafeArea _propertiesView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: _propertiesNavigator(),
      ),
    );
  }

  Column _propertiesNavigator() {
    switch (_currentListOnPage) {
      case ListOnPage.participants:
        return _propertiesParticipants();
      case ListOnPage.classes:
        return _propertiesClasses();
    }
  }

  Container _pageTitle() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            group.name,
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
          Text(
            Strings.GROUP_OF_CLASSES.toLowerCase(),
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Column _propertiesParticipants() {
    return Column(
      children: [
        _pageTitle(),
        OneRowPropertyTemplate(
            title: Strings.CLASSES_TYPE, value: group.classesType.target!.name),
        OneRowPropertyTemplate(
            title: Strings.CLASSES_ADDRESS,
            value: group.address.target.toString()),
        OneRowPropertyTemplate(
            title: Strings.NUMBER_OF_STUDENTS,
            value: group.students.length.toString()),
      ],
    );
  }

  Column _propertiesClasses() {
    return Column(
      children: [
        _pageTitle(),
        OneRowPropertyTemplate(
            title: Strings.CLASSES_TYPE, value: group.classesType.target!.name),
        OneRowPropertyTemplate(
            title: Strings.CLASSES_ADDRESS,
            value: group.address.target.toString()),
        OneRowPropertyTemplate(
            title: Strings.NUMBER_OF_CLASSES,
            value: group.classes.length.toString()),
      ],
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
