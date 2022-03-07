import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/list_items/students_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class StudentsMainPage extends StatefulWidget {
  const StudentsMainPage({Key? key}) : super(key: key);

  @override
  _StudentsMainPageState createState() => _StudentsMainPageState();
}

class _StudentsMainPageState extends State<StudentsMainPage> {
  late Stream<List<Student>> _studentsStream;
  bool _isSortingAscending = true;
  late List<Student> _studentsList, _filteredStudentsList;

  static const double titleHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Student>>(
      stream: _studentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _studentsList = snapshot.data!;
          return Scaffold(
            floatingActionButton: SpeedDial(
              icon: Icons.add,
              backgroundColor: Colors.amber,
              onPress: _navigateToCreateStudent,
            ),
            body: CustomScrollView(
              slivers: [
                _customAppBar(),
                _content(),
              ],
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
          children: [
            _pageNavigationButton(isAscending: true),
            _pageNavigationButton(isAscending: false)
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

  void _navigateToCreateStudent() =>
      Navigator.pushNamed(context, AppUrls.CREATE_STUDENT,
          arguments: _addStudentToDb);

  void _addStudentToDb(Student student) {
    setState(() {
      student.addToDb();
    });
  }

  SafeArea _propertiesView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppStrings.STUDENT_MANAGEMENT,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                OneRowPropertyTemplate(
                  title: '${AppStrings.NUMBER_OF_STUDENTS}:',
                  value: _studentsList.length.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DecoratedBox _pageNavigationButton(
      {required bool isAscending}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: _isSortingAscending == isAscending
                ? Colors.black12
                : Colors.transparent,
            offset: const Offset(0, -1),
            blurRadius: 4,
          )
        ],
      ),
      child: IconButton(
        icon: Icon(
          isAscending == true
              ? Icons.arrow_drop_down_sharp
              : Icons.arrow_drop_up_sharp,
          color: Colors.white,
        ),
        onPressed: () => setState(() => _isSortingAscending = isAscending),
      ),
    );
  }

  SliverList _content() {
    _filterListAlphabetically();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => StudentsListItemTemplate(
          student: _filteredStudentsList.elementAt(index),
          removeFromDb: _removeStudentFromDb,
          updateInDb: _updateStudent,
        ),
        childCount: _studentsList.length,
      ),
    );
  }

  void _filterListAlphabetically() {
    _filteredStudentsList = _studentsList;
    if (_isSortingAscending) {
      _filteredStudentsList.sort((student1, student2) => student1
          .person.target!.surname
          .compareTo(student2.person.target!.surname));
    } else {
      _filteredStudentsList.sort((student1, student2) => student1
                  .person.target!.surname
                  .compareTo(student2.person.target!.surname) ==
              1
          ? 0
          : 1);
    }
  }

  void _removeStudentFromDb(Student student) {
    setState(() {
      student.removeFromDb();
    });
  }

  void _updateStudent(Student student, Student updatingValues) {
    setState(() {
      student.updateValues(updatingValues);
    });
  }

  @override
  void initState() {
    super.initState();
    _studentsStream = ObjectBox.store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
