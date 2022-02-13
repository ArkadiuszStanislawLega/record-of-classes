import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
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
  late Group _group;
  late Function? _updateGroupFunction;
  late Map _args;
  ListOnPage _currentListOnPage = ListOnPage.classes;

  late Stream<List<Student>> _studentsStream;

  static const double titleHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _group = _args[AppStrings.GROUP];
    _updateGroupFunction = _args[AppStrings.FUNCTION];
    return StreamBuilder<List<Student>>(
      stream: _studentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _group.getFromDb();
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
                    label: AppStrings.ADD_PARTICIPANTS,
                    backgroundColor: Colors.amberAccent,
                    onTap: _navigateToAddStudent),
                SpeedDialChild(
                    child: const Icon(Icons.class__outlined),
                    label: AppStrings.ADD_CLASSES,
                    backgroundColor: Colors.amberAccent,
                    onTap: _navigateToAddClasses),
                SpeedDialChild(
                    child: const Icon(Icons.edit),
                    label: AppStrings.EDIT,
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
      Navigator.pushNamed(context, AppUrls.ADD_CLASSES_TO_GROUP, arguments: {
        AppStrings.GROUP: _group,
        AppStrings.FUNCTION: _addClassesToGroup
      });

  void _addClassesToGroup(Classes classes) {
    setState(() {
      _group.addClasses(classes);
    });
  }

  void _navigateToAddStudent() =>
      Navigator.pushNamed(context, AppUrls.ADD_STUDENT_TO_GROUP,
          arguments: _group);

  _navigateToEditGroupPage() => Navigator.pushNamed(context, AppUrls.EDIT_GROUP,
      arguments: {AppStrings.GROUP: _group, AppStrings.FUNCTION: _updateGroup});

  void _updateGroup(Group updated) {
    if (_updateGroupFunction != null) {
      _updateGroupFunction!(updated);
    }

    setState(() {
      _group = updated;
    });
  }

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: const Size(0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _pageNavigationButton(
                title: AppStrings.LIST_OF_CLASSES_CONDUCTED,
                listOnPage: ListOnPage.classes),
            _pageNavigationButton(
                title: AppStrings.PARTICIPANTS,
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
          classes: _group.classes.elementAt(index),
          removeFromDbFunction: _removeClassesFromDb,
        ),
        childCount: _group.classes.length,
      ),
    );
  }

  void _removeClassesFromDb(Classes classes) {
    setState(() {
      classes.removeFromDb();
    });
  }

  SliverList _participantsSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => StudentsInGroupListItemTemplate(
          group: _group,
          student: _group.students.elementAt(index),
        ),
        childCount: _group.students.length,
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
                title: AppStrings.CLASSES_TYPE,
                value: _group.classesType.target!.name),
            OneRowPropertyTemplate(
                title: AppStrings.CLASSES_ADDRESS,
                value: _group.address.target.toString()),
            OneRowPropertyTemplate(
                title: AppStrings.NUMBER_OF_STUDENTS,
                value: _group.students.length.toString()),
            OneRowPropertyTemplate(
                title: AppStrings.NUMBER_OF_CLASSES,
                value: _group.classes.length.toString()),
          ],
        ),
      ),
    );
  }

  Container _pageTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            _group.name,
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            AppStrings.GROUP_OF_CLASSES.toLowerCase(),
            style: Theme.of(context).textTheme.headline2,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _studentsStream = objectBox.store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
