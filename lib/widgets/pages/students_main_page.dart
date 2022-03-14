import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/list_items/students_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

import '../../objectbox.g.dart';

class StudentsMainPage extends StatefulWidget {
  const StudentsMainPage({Key? key}) : super(key: key);

  @override
  _StudentsMainPageState createState() => _StudentsMainPageState();
}

class _StudentsMainPageState extends State<StudentsMainPage> {
  static const double titleHeight = 220.0;

  late Stream<List<Student>> _studentsStream;
  late List<Student> _studentsList;

  final List<Student> _filteredStudentsList = [];

  String _inputSurname = '';
  int _inputAge = 0;
  bool _isSortingAscending = true;

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
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    style: Theme.of(context).textTheme.headline2,
                    onChanged: (input) {
                      _inputSurname = input;
                      setState(() {
                        _filterBySurnameAndAge();
                      });
                    },
                    decoration: InputDecoration(
                      label: Text(AppStrings.findStudent,
                          style: Theme.of(context).textTheme.headline2),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5 - 100,
                  child: TextField(
                    style: Theme.of(context).textTheme.headline2,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (input) {
                      _updateInputAge(input);
                    },
                    decoration: InputDecoration(
                      label: Text(AppStrings.studentAge,
                          style: Theme.of(context).textTheme.headline2),
                    ),
                  ),
                ),
                _pageNavigationButton(isAscending: true),
                _pageNavigationButton(isAscending: false)
              ],
            ),
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

  void _updateInputAge(String input) {
    setState(
      () {
        if (input != '') {
          _inputAge = int.tryParse(input)! > 0 ? int.parse(input) : 0;
          _filterBySurnameAndAge();
        } else {
          _inputAge = 0;
        }
      },
    );
  }

  void _navigateToCreateStudent() =>
      Navigator.pushNamed(context, AppUrls.createStudent,
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
                    AppStrings.studentManagement,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                OneRowPropertyTemplate(
                  title: '${AppStrings.numberOfStudents}:',
                  value: _studentsList.length.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DecoratedBox _pageNavigationButton({required bool isAscending}) {
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
    _filterBySurnameAndAge();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => StudentsListItemTemplate(
          student: _filteredStudentsList.elementAt(index),
          removeFromDb: _removeStudentFromDb,
          updateInDb: _updateStudent,
        ),
        childCount: _filteredStudentsList.length,
      ),
    );
  }

  List<Person> _getAllStudents() {
    return ObjectBox.store
        .box<Person>()
        .query(Person_.personType.equals(2))
        .build()
        .find();
  }

  List<Person> _getStudentsContainsInput() {
    return ObjectBox.store
        .box<Person>()
        .query(Person_.surname.contains(_inputSurname)
          ..and(Person_.personType.equals(2)))
        .build()
        .find();
  }

  List<Person> _getPersonsList() {
    List<Person> lp =
        _inputSurname == '' ? _getAllStudents() : _getStudentsContainsInput();
    return lp;
  }

  List<Person> _sortStudentsList() {
    List<Person> lp = _getPersonsList();
    if (_isSortingAscending) {
      lp.sort((person1, person2) => person1.surname.compareTo(person2.surname));
    } else {
      lp.sort((student1, student2) =>
          student1.surname.compareTo(student2.surname) == 1 ? 0 : 1);
    }
    return lp;
  }

  void _filterBySurnameAndAge() {
    _filteredStudentsList.clear();

    if (_inputAge > 0) {
      _filterByAge();
    } else {
      _filterOnlyBySurname();
    }
  }

  void _filterOnlyBySurname() {
    List<Person> lp = _sortStudentsList();
    if (lp.isNotEmpty) {
      for (var person in lp) {
        if (person.personType == 2) {
          person.student.target == null
              ? ''
              : _filteredStudentsList.add(person.student.target!);
        }
      }
    }
  }

  void _filterByAge() {
    List<Person> lp = _sortStudentsList();
    for (var person in lp) {
      if (person.personType == 2 && person.student.target!.age == _inputAge) {
        _filteredStudentsList.add(person.student.target!);
      }
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
