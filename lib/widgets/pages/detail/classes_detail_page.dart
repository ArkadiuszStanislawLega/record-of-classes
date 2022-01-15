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
  @override
  Widget build(BuildContext context) {
    widget._classes = ModalRoute.of(context)!.settings.arguments as Classes;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget._classes.group.target!.name),
          bottom: const TabBar(
            tabs: [Tab(text: 'Uczniowie'), Tab(text: 'List obecności')],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Text(
                    '${widget._classes.group.target!.name} ${widget._classes.dateTime}'),
                ListView.builder(
                  itemCount: widget._classes.group.target!.students.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _attendanceItemList(widget
                        ._classes.group.target!.students
                        .elementAt(index));
                  },
                )
              ],
            ),
            ListView.builder(
                itemCount: widget._classes.attendances.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index){
              return _attendanceUneditedItemList(widget._classes.attendances.elementAt(index));
            })
          ],
        ),
      ),
    );
  }


  Widget _attendanceUneditedItemList(Attendance attendance){
    return ListTile(
      tileColor: attendance.isPresent ? Colors.green : Colors.orange,
      title: Text(attendance.student.target!.introduceYourself()),
      subtitle: Row(
        children: [
          Text(attendance.student.target!.account.target!.bills.skipWhile((bill) => bill.isPaid).length.toString())
        ],
      ),
    );
  }

  Widget _attendanceItemList(Student student) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: Strings.ADD,
          color: Colors.green,
          icon: Icons.check,
          onTap: () {
            _updateDatabase(student);
          },
        ),
      ],
      child: ListTile(title: Text(student.introduceYourself()), onTap: () {}),
    );
  }

  void _updateDatabase(Student student){
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
        ..price = widget._classes.group.target!.classesType.target!.priceForEach;
      student.account.target!.bills.add(bill);
      store.box<Bill>().put(bill);
      store.box<Classes>().put(widget._classes);
      store.box<Attendance>().put(attendance);
      store.box<Student>().put(student);
    });
  }
}
