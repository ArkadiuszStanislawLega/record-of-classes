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
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class DetailGroupPage extends StatefulWidget {
  const DetailGroupPage({Key? key}) : super(key: key);

  @override
  _DetailGroupPageState createState() => _DetailGroupPageState();
}

enum ListOnPage { participants, classes }

class _DetailGroupPageState extends State<DetailGroupPage> {
  late Group group;
  ListOnPage _currentListOnPage = ListOnPage.classes;

  late Store _store;
  late Stream<List<Student>> _studentsStream;

  static const double titleHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    group = ModalRoute.of(context)!.settings.arguments as Group;
    return StreamBuilder<List<Student>>(
      stream: _studentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          group = _store.box<Group>().get(group.id)!;
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                _customAppBar(),
                _content(),
              ],
            ),
            floatingActionButton: SpeedDial(
              icon: Icons.settings,
              backgroundColor: Colors.amber,
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.person),
                    label: Strings.ADD_PARTICIPANTS,
                    backgroundColor: Colors.amberAccent,
                    onTap: _navigateToAddStudent),
                SpeedDialChild(
                    child: const Icon(Icons.class__outlined),
                    label: Strings.ADD_CLASSES,
                    backgroundColor: Colors.amberAccent,
                    onTap: _navigateToAddClasses),
                SpeedDialChild(
                    child: const Icon(Icons.edit),
                    label: Strings.EDIT,
                    backgroundColor: Colors.amberAccent,
                    onTap: _navigateToEditGroupPage),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _navigateToAddClasses() =>
      Navigator.pushNamed(context, AppUrls.ADD_CLASSES_TO_GROUP,
          arguments: group);

  void _navigateToAddStudent() =>
      Navigator.pushNamed(context, AppUrls.ADD_STUDENT_TO_GROUP,
          arguments: group);

  _navigateToEditGroupPage() =>
      Navigator.pushNamed(context, AppUrls.EDIT_GROUP, arguments: group);

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: const Size(0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _pageNavigationButton(
                title: Strings.LIST_OF_CLASSES_CONDUCTED, listOnPage: ListOnPage.classes),
            _pageNavigationButton(
                title: Strings.PARTICIPANTS,
                listOnPage: ListOnPage.participants),
          ],
        ),
      ),
      stretch: true,
      onStretchTrigger: () => Future<void>.value(),
      expandedHeight: titleHeight,
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
        child: Column(
          children: [
            _pageTitle(),
            OneRowPropertyTemplate(
                title: Strings.CLASSES_TYPE,
                value: group.classesType.target!.name),
            OneRowPropertyTemplate(
                title: Strings.CLASSES_ADDRESS,
                value: group.address.target.toString()),
            OneRowPropertyTemplate(
                title: Strings.NUMBER_OF_STUDENTS,
                value: group.students.length.toString()),
            OneRowPropertyTemplate(
                title: Strings.NUMBER_OF_CLASSES,
                value: group.classes.length.toString()),
          ],
        ),
      ),
    );
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
