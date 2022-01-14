import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/group.dart';

class AddClassesToGroup extends StatefulWidget {
  AddClassesToGroup({Key? key}) : super(key: key);
  late Group _group;

  @override
  State<StatefulWidget> createState() => _AddClassesToGroup();
}

class _AddClassesToGroup extends State<AddClassesToGroup> {
  DateTime selectedDate = DateTime.now(),
  selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    widget._group = ModalRoute.of(context)!.settings.arguments as Group;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._group.name),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2022, 1, 1),
                      maxTime: DateTime(2100, 1, 1), onConfirm: (date) {
                    setState(() {
                      selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          selectedTime.hour,
                          selectedTime.minute);
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.pl);
                },
                child: const Text(
                  Strings.CHOSE_DATE,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  DatePicker.showTimePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    setState(() {
                      selectedTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          date.hour,
                          date.minute);
                    });
                  }, currentTime: DateTime.now());
                },
                child: const Text(
                  Strings.CHOSE_TIME,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("${selectedDate.toLocal()}".split(' ')[0]),
              Text(DateFormat.Hm().format(selectedTime))
            ],
          ),
          TextButton(onPressed: _addToDatabase, child: const Text(Strings.ADD))
        ],
      ),
    );
  }

  void _addToDatabase() {
    Store store = objectBox.store;
    Classes classes = Classes()
      ..group.target = widget._group
      ..dateTime = selectedDate;
    widget._group.classes.add(classes);
    classes.group.target = widget._group;
    store.box<Group>().put(widget._group);
  }
}
