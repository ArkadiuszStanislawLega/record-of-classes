import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
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

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: const Size(0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 3,
                    color: _isWrittenOpen ? Colors.black12 : Colors.transparent,
                    offset: const Offset(0, -3),
                    blurRadius: 10,
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
                  'Zapisani',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 3,
                    color: !_isWrittenOpen ? Colors.black12: Colors.transparent,
                    offset: const Offset(0, -3),
                    blurRadius: 10,
                  )
                ],
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isWrittenOpen = false;
                  });
                },
                child: const Text(
                  'Obecni',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      stretch: true,
      onStretchTrigger: () {
        // Function callback for stretch
        return Future<void>.value();
      },
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
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget._classes.group.target!.name,
                        style:
                            const TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                    OneRowPropertyTemplate(
                      title: 'Data zajęć:',
                      value: FormatDate(widget._classes.dateTime),
                    ),
                    OneRowPropertyTemplate(
                      title: 'Ilość uczestników:',
                      value: widget._classes.attendances.length.toString(),
                    ),
                    OneRowPropertyTemplate(
                        title: 'Obecnych:',
                        value: widget._classes.attendances.length.toString()),
                  ],
                ),
              ),
            ),
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

  @override
  Widget build(BuildContext context) {
    widget._classes = ModalRoute.of(context)!.settings.arguments as Classes;
    return StreamBuilder<List<Classes>>(
      stream: _classesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  _customAppBar(),
                  _isWrittenOpen
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _attendanceItemList(widget
                                  ._classes.group.target!.students
                                  .elementAt(index));
                            },
                            childCount:
                                widget._classes.group.target!.students.length,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return _attendanceUneditedItemList(
                                  widget._classes.attendances.elementAt(index));
                            },
                            childCount: widget._classes.attendances.length,
                          ),
                        ),
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

  Widget _attendanceUneditedItemList(Attendance attendance) {
    return ListTile(
      tileColor: attendance.isPresent ? Colors.green : Colors.orange,
      title: Text(attendance.student.target!.introduceYourself()),
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
            _updateDatabase(student);
          },
        ),
      ],
      child: ListTile(
        title: Text(student.introduceYourself()),
        onTap: () {},
        subtitle: Text(
            'Nieopłacone zajęcia: ${_numberOfUnpaidBills(student.account.target!.bills)}'),
      ),
    );
  }

  void _updateDatabase(Student student) {
    setState(() {
      Store store = objectBox.store;
      Attendance attendance = Attendance()
        ..student.target = student
        ..classes.target = widget._classes
        ..isPresent = true;
      widget._classes.attendances.add(attendance);
      Bill bill = Bill()
        ..student.target = student.account.target
        ..classes.target = widget._classes
        ..isPaid = false
        ..price =
            widget._classes.group.target!.classesType.target!.priceForEach;
      student.account.target!.bills.add(bill);
      store.box<Bill>().put(bill);
      store.box<Classes>().put(widget._classes);
      store.box<Attendance>().put(attendance);
      store.box<Student>().put(student);
    });
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
