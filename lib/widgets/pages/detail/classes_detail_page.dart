import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/student.dart';

class ClassesDetailPage extends StatefulWidget {
  ClassesDetailPage({Key? key}) : super(key: key);
  late Classes _classes;

  @override
  _ClassesDetailPageState createState() => _ClassesDetailPageState();
}

class _ClassesDetailPageState extends State<ClassesDetailPage> {
  late Store _store;
  late Stream<List<Classes>> _classesStream;

  @override
  Widget build(BuildContext context) {
    widget._classes = ModalRoute.of(context)!.settings.arguments as Classes;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: StreamBuilder<List<Classes>>(
          stream: _classesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: <Widget>[
                  SliverAppBar(
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
                      title: const Text(Strings.FINANCE),
                      background: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          SafeArea(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _oneRow('${Strings.PAID_CLASSES}:',
                                      _paid.length.toString()),
                                  _oneRow('${Strings.UNPAID_CLASSES}:',
                                      _unpaid.length.toString()),
                                  _oneRow('${Strings.TOTAL_PAID}:',
                                      '${_paidPrice.toStringAsFixed(2)} ${Strings.CURRENCY}'),
                                  _oneRow('${Strings.TOTAL_UNPAID}:',
                                      '${_unpaidPrice.toStringAsFixed(2)} ${Strings.CURRENCY}'),
                                ],
                              ),
                            ),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.0, 0.5),
                                end: Alignment.center,
                                colors: <Color>[
                                  Colors.black12,
                                  Colors.transparent
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return BillListItem(
                            bill: _isPaidFilter
                                ? _paid.elementAt(index)
                                : _unpaid.elementAt(index));
                      },
                      childCount: _isPaidFilter
                          ? _paid.length
                          : _unpaid.length, // 1000 list items
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),

        //
        //   TabBarView(
        //     children: [
        //       ListView.builder(
        //         itemCount: widget._classes.group.target!.students.length,
        //         scrollDirection: Axis.vertical,
        //         shrinkWrap: true,
        //         itemBuilder: (context, index) {
        //           return _attendanceItemList(
        //               widget._classes.group.target!.students.elementAt(index));
        //         },
        //       ),
        //       ListView.builder(
        //           itemCount: widget._classes.attendances.length,
        //           scrollDirection: Axis.vertical,
        //           shrinkWrap: true,
        //           itemBuilder: (context, index) {
        //             return _attendanceUneditedItemList(
        //                 widget._classes.attendances.elementAt(index));
        //           })
        //     ],
        //   ),
        // ),
      ),
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
