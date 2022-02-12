import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class ClassesDetailPage extends StatefulWidget {
  ClassesDetailPage({Key? key}) : super(key: key);
  late Classes _classes;

  @override
  _ClassesDetailPageState createState() => _ClassesDetailPageState();
}

class _ClassesDetailPageState extends State<ClassesDetailPage> {
  bool _isWrittenOpen = true;

  static const double titleHeight = 250.0;
  late Map _args;
  late Function? _parentUpdateFunction;

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _parentUpdateFunction = _args[AppStrings.FUNCTION];
    widget._classes = _args[AppStrings.CLASSES];
    widget._classes.getFromDb();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _customAppBar(),
          _content(),
        ],
      ),
    );
  }

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: const Size(0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _changeListForSignedUpButton(),
            _changeListForPresentsButton(),
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

  DecoratedBox _changeListForSignedUpButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: _isWrittenOpen ? Colors.black12 : Colors.transparent,
            offset: const Offset(0, -1),
            blurRadius: 4,
          )
        ],
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            _isWrittenOpen = true;
          });
        },
        child: const Text(
          AppStrings.SIGNED_UP_FOR_CLASSES,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  DecoratedBox _changeListForPresentsButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: !_isWrittenOpen ? Colors.black12 : Colors.transparent,
            offset: const Offset(0, -1),
            blurRadius: 4,
          )
        ],
      ),
      child: TextButton(
        onPressed: () => setState(() => _isWrittenOpen = false),
        child: const Text(
          AppStrings.PRESENTS_AT_THE_CLASSSES,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
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
              child: Column(
                children: [
                  Text(
                    widget._classes.group.target!.name,
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Text(AppStrings.CLASSES_CONDUCTED.toLowerCase(),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.DATE_OF_CLASSES}:',
              value: formatDate(widget._classes.dateTime),
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.NUMBER_OF_SIGNED_UP}:',
              value: widget._classes.group.target!.students.length.toString(),
            ),
            OneRowPropertyTemplate(
                title: '${AppStrings.PRESENTS_AT_THE_CLASSSES}:',
                value: widget._classes.attendances
                    .skipWhile((element) => !element.isPresent)
                    .length
                    .toString()),
          ],
        ),
      ),
    );
  }

  SliverList _content() =>
      _isWrittenOpen ? _studentsSliverList() : _attendancesSliverList();

  SliverList _studentsSliverList() {
    List<Student> studentsList = _filteredStudentsList();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) =>
            _attendanceItemList(studentsList.elementAt(index)),
        childCount: studentsList.length,
      ),
    );
  }

  List<Student> _filteredStudentsList() {
    List<Student> studentsList = [];
    for (var student in widget._classes.group.target!.students) {
      bool isInAttendancesList = false;
      for (var attendance in student.attendancesList) {
        if (attendance.classes.targetId == widget._classes.id) {
          isInAttendancesList = true;
        }
      }
      if (!isInAttendancesList) {
        studentsList.add(student);
      }
    }
    return studentsList;
  }

  SliverList _attendancesSliverList() {
    List<Attendance> attendancesList = widget._classes.attendances;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) =>
            _attendanceUneditedItemList(attendancesList.elementAt(index)),
        childCount: attendancesList.length,
      ),
    );
  }

  Widget _attendanceUneditedItemList(Attendance attendance) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: attendance.isPresent ? AppStrings.ABSENT : AppStrings.ABSENT,
          color: attendance.isPresent ? Colors.orange : Colors.green,
          icon: attendance.isPresent
              ? Icons.check_box_outline_blank
              : Icons.check,
          onTap: () {
            setState(() {
              attendance.isPresent
                  ? _removeAttendance(attendance)
                  : _makeAttendancesInClasses(attendance.student.target!);
            });
          },
        ),
      ],
      child: ListTile(
        tileColor: attendance.isPresent ? Colors.orange : Colors.grey,
        title: Text(attendance.student.target!.introduceYourself()),
        onTap: () {},
        subtitle: Text(
            '${AppStrings.UNPAID_CLASSES}: ${attendance.student.target!.account.target!.countUnpaidBills()}'),
      ),
    );
  }

  void _removeAttendance(Attendance attendance) {
    setState(() {
      attendance.removeFromDb();
    });

    if (_parentUpdateFunction != null) {
      _parentUpdateFunction!(widget._classes);
    }
  }

  void _makeAttendancesInClasses(Student student) {
    Account studentAccount = student.account.target!;
    Classes currentClasses = widget._classes;
    ClassesType currentClassesType =
        currentClasses.group.target!.classesType.target!;

    Attendance attendance = _createAttendance(student);
    Bill bill = _createBill(
        account: studentAccount,
        attendance: attendance,
        price: currentClassesType.priceForEach);

    attendance.setBill(bill);

    _makeRelationsOfAttendances(
        student: student,
        attendance: attendance,
        currentClasses: currentClasses);

    if (_parentUpdateFunction != null) {
      _parentUpdateFunction!(widget._classes);
    }
  }

  Attendance _createAttendance(Student student) {
    Attendance attendance = Attendance()
      ..isPresent = true
      ..student.target = student
      ..classes.target = widget._classes;
    attendance.addToDb();
    return attendance;
  }

  Bill _createBill(
      {required account,
      required Attendance attendance,
      required double price}) {
    Bill bill = Bill()
      ..studentAccount.target = account
      ..attendance.target = attendance
      ..isPaid = false
      ..price = price;
    bill.addToDb();
    return bill;
  }

  void _makeRelationsOfAttendances(
      {required student,
      required Attendance attendance,
      required Classes currentClasses}) {
    student.addAttendance(attendance);
    currentClasses.addAttendance(attendance);
  }

  Widget _attendanceItemList(Student student) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: AppStrings.PRESENT,
          color: Colors.green,
          icon: Icons.check,
          onTap: () {
            setState(() {
              _makeAttendancesInClasses(student);
            });
          },
        ),
      ],
      child: ListTile(
        title: Text(student.introduceYourself()),
        onTap: () {},
        subtitle: Text(
            '${AppStrings.UNPAID_CLASSES}: ${_numberOfUnpaidBills(student.account.target!.bills)}'),
      ),
    );
  }

  int _numberOfUnpaidBills(List<Bill> bills) {
    int counter = 0;
    for (var bill in bills) {
      if (!bill.isPaid) {
        counter++;
      }
    }
    return counter;
  }
}
