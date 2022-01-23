import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/list_items/parent_list_item_template.dart';

class AddParentPage extends StatefulWidget {
  const AddParentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateParentPage();
  }
}

class _CreateParentPage extends State<AddParentPage> {
  late Student _selectedStudent;
  late Stream<List<Parent>> _parentsStream;
  List<Parent> _parentsList = [];
  late Function _addFunction, _removeFunction;
  late Map _args;

  static const titleHeight = 100.0;

  @override
  void initState() {
    super.initState();
    _parentsStream = objectBox.store
        .box<Parent>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _selectedStudent = _args[Strings.STUDENT];
    _addFunction = _args[Strings.ADD_FUNCTION];
    _removeFunction = _args[Strings.REMOVE_FUNCTION];

    return StreamBuilder<List<Parent>>(
      stream: _parentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _parentsList = snapshot.data!;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              floatingActionButton: SpeedDial(
                icon: Icons.add,
                backgroundColor: Colors.amber,
                onPress: _navigateToCreateParentPage,
              ),
              body: CustomScrollView(
                slivers: [
                  _customAppBar(),
                  _content(),
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
            _pageTitle(),
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

  void _navigateToCreateParentPage() =>
      Navigator.pushNamed(context, AppUrls.CREATE_PARENT,
          arguments: _selectedStudent);

  SliverList _content() => _studentsSliverList();

  SliverList _studentsSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => ParentListItemTemplate(
          parent: _parentsList.elementAt(index),
          student: _selectedStudent,
          addFunction: _addFunction,
          removeFunction: _removeFunction,
        ),
        childCount: _parentsList.length,
      ),
    );
  }

  SafeArea _pageTitle() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _selectedStudent.introduceYourself(),
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
