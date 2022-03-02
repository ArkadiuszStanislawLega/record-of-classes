import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class AddClassesToGroup extends StatefulWidget {
  AddClassesToGroup({Key? key}) : super(key: key);
  late Group _group;
  DateTime selectedDate = DateTime.now(), selectedTime = DateTime.now();

  Classes getClasses() {
    Classes classes = Classes()
      ..group.target = _group
      ..dateTime = DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute);
    return classes;
  }

  @override
  State<StatefulWidget> createState() => _AddClassesToGroup();
}

class _AddClassesToGroup extends State<AddClassesToGroup> {
  late Function _addClasses;
  Map _args = {};

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    widget._group = _args[AppStrings.GROUP];
    _addClasses = _args[AppStrings.FUNCTION];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._group.name, style: Theme.of(context).textTheme.headline1,),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.CHOSE_DATE_OF_CLASSES,
              style: Theme.of(context).textTheme.headline3
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2022, 1, 1),
                            maxTime: DateTime(2100, 1, 1), onConfirm: (date) {
                          setState(() {
                            widget.selectedDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                widget.selectedTime.hour,
                                widget.selectedTime.minute);
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.pl);
                      },
                      child: Text(
                        AppStrings.CHOSE_DATE,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    Text(
                      formatDate(widget.selectedDate),
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            showTitleActions: true, onConfirm: (date) {
                          setState(() {
                            widget.selectedTime = DateTime(
                                widget.selectedDate.year,
                                widget.selectedDate.month,
                                widget.selectedDate.day,
                                date.hour,
                                date.minute);
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.pl);
                      },
                      child: Text(
                        AppStrings.CHOSE_TIME,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    Text(
                      formatTime(widget.selectedTime),
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
                onPressed: _addToDatabase, child: const Text(AppStrings.ADD))
          ],
        ),
      ),
    );
  }

  void _addToDatabase() {
    setState(() {
      _addClasses(widget.getClasses());
      SnackBarInfoTemplate(
          context: context,
          message:
              '${AppStrings.CREATED_NEW_CLASSES} ${AppStrings.IN_DAY} ${formatDate(widget.getClasses().dateTime)}');
    });
    Navigator.pop(context);
  }
}
