import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/objectbox.g.dart';
import 'package:record_of_classes/widgets/templates/list_items/students_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class StudentsMainPage extends StatefulWidget {
  const StudentsMainPage({Key? key}) : super(key: key);

  @override
  _StudentsMainPageState createState() => _StudentsMainPageState();
}

class _StudentsMainPageState extends State<StudentsMainPage> {
  late Store _store;
  late Stream<List<Student>> _studentsStream;
  late List<Student> _studentsList;

  static const double titleHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Student>>(
      stream: _studentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _studentsList = snapshot.data!;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
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
      objectBox.store.box<Student>().put(student);
    });
  }

  SafeArea _propertiesView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                Strings.STUDENT_MANAGEMENT,
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            OneRowPropertyTemplate(
              title: '${Strings.NUMBER_OF_STUDENTS}:',
              value: _studentsList.length.toString(),
            ),
          ],
        ),
      ),
    );
  }

  SliverList _content() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => StudentsListItemTemplate(
          student: _studentsList.elementAt(index),
          removeFromDb: _removeStudentFromDb,
          updateInDb: _updateStudent,
        ),
        childCount: _studentsList.length,
      ),
    );
  }

  void _removeStudentFromDb(Student student) {
    setState(() {
      student.removeFromDb();
    });
  }

  void _updateStudent(Student student, Student updatingValues){
    setState(() {
      student.updateValues(updatingValues);
    });
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
