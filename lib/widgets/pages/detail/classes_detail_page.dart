import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class ClassesDetailPage extends StatefulWidget {
  ClassesDetailPage({Key? key}) : super(key: key);
  late Classes _classes;

  @override
  _ClassesDetailPageState createState() => _ClassesDetailPageState();
}

class _ClassesDetailPageState extends State<ClassesDetailPage> {
  late Store _store;
  late Stream<List<Classes>> _classesStream;
  bool _isWrittenOpen = true;

  static const double titleHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    widget._classes = ModalRoute.of(context)!.settings.arguments as Classes;
    return StreamBuilder<List<Classes>>(
      stream: _classesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          widget._classes =
              objectBox.store.box<Classes>().get(widget._classes.id)!;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
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
          Strings.SIGNED_UP_FOR_CLASSES,
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
          Strings.PRESENTS_AT_THE_CLASSSES,
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
                  Text(Strings.CLASSES_CONDUCTED.toLowerCase(),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            ),
            OneRowPropertyTemplate(
              title: '${Strings.DATE_OF_CLASSES}:',
              value: FormatDate(widget._classes.dateTime),
            ),
            OneRowPropertyTemplate(
              title: '${Strings.NUMBER_OF_SIGNED_UP}:',
              value: widget._classes.group.target!.students.length.toString(),
            ),
            OneRowPropertyTemplate(
                title: '${Strings.PRESENTS_AT_THE_CLASSSES}:',
                value: widget._classes.attendances.length.toString()),
          ],
        ),
      ),
    );
  }

  SliverList _content() =>
      _isWrittenOpen ? _studentsSliverList() : _attendancesSliverList();

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
          caption: attendance.isPresent ? Strings.ABSENT : Strings.ABSENT,
          color: attendance.isPresent ? Colors.orange : Colors.green,
          icon: attendance.isPresent
              ? Icons.check_box_outline_blank
              : Icons.check,
          onTap: () {
            attendance.isPresent
                ? _setAbsentUpdateDb(attendance)
                : _setPresentUpdateDatabase(attendance.student.target!);
          },
        ),
      ],
      child: ListTile(
        tileColor: attendance.isPresent ? Colors.orange : Colors.grey,
        title: Text(attendance.student.target!.introduceYourself()),
        onTap: () {},
        subtitle: Text(
            '${Strings.UNPAID_CLASSES}: ${_numberOfUnpaidBills(attendance.student.target!.account.target!.bills)}'),
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

  Widget _attendanceItemList(Student student) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: Strings.PRESENT,
          color: Colors.green,
          icon: Icons.check,
          onTap: () {
            _setPresentUpdateDatabase(student);
          },
        ),
      ],
      child: ListTile(
        title: Text(student.introduceYourself()),
        onTap: () {},
        subtitle: Text(
            '${Strings.UNPAID_CLASSES}: ${_numberOfUnpaidBills(student.account.target!.bills)}'),
      ),
    );
  }

  void _setAbsentUpdateDb(Attendance attendance) {
    setState(() {
      Store store = objectBox.store;
      attendance.isPresent = false;

      store.box<Bill>().remove(attendance.bill.target!.id);
      store.box<Attendance>().put(attendance);

      var tt = store.box<Attendance>().get(attendance.id);
      print(tt?.bill.target);
    });
  }

  void _setPresentUpdateDatabase(Student student) {
    setState(() {
      if (student.attendancesList.isNotEmpty) {
        for (var element in student.attendancesList) {
          if (element.classes.targetId == widget._classes.id) {
            element.isPresent = true;
            _addBillToAttendanceInDb(attendance: element, student: student);
          }
        }
      }
      _addBillToAttendanceInDb(attendance: Attendance(), student: student);
    });
  }

  void _addBillToAttendanceInDb(
      {required Attendance attendance, required Student student}) {
    attendance.isPresent = true;

    if (attendance.id == 0) {
      attendance
        ..student.target = student
        ..classes.target = widget._classes;
      widget._classes.attendances.add(attendance);
    }

    Bill bill = Bill()
      ..studentAccount.target = student.account.target
      ..attendance.target = attendance
      ..isPaid = false
      ..price = widget._classes.group.target!.classesType.target!.priceForEach;

    attendance.bill.target = bill;
    student.account.target!.balance -= bill.price;
    student.account.target!.bills.add(bill);
    student.attendancesList.add(attendance);

    Store store = objectBox.store;
    store.box<Bill>().put(bill);
    store.box<Classes>().put(widget._classes);
    store.box<Attendance>().put(attendance);
    store.box<Student>().put(student);
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _classesStream = _store
        .box<Classes>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
