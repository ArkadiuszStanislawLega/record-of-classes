import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/enumerators/ModelType.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/log.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/widgets/templates/list_items/log_list_item_template.dart';

import '../../objectbox.g.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String _input = '';
  List<Log> _logs = [];

  @override
  Widget build(BuildContext context) {
    _prepareList();
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size(0, 10),
          child: TextField(
            style: Theme.of(context).textTheme.headline2,
            onChanged: (input) {
              setState(() {
                _input = input;
              });
            },
          ),
        ),
        title: Text(
          AppStrings.operationHistory,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Center(
        child: _list(),
      ),
    );
  }

  void _prepareList() {
    _input == '' ? _emptyFilterInput() : _getLogsDependsOnStudentSurname();
  }

  void _emptyFilterInput() {
    setState(() {
      if (_logs.isNotEmpty) {
        _logs.clear();
      }
      _logs = ObjectBox.store.box<Log>().getAll();
      _logs.sort(
          (firstLog, secondLog) => firstLog.date.compareTo(secondLog.date));
    });
  }

  Widget _list() {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(8),
      itemCount: _logs.length,
      itemBuilder: (BuildContext context, int index) {
        return LogListItemTemplate(log: _logs[index]);
      },
    );
  }

  void _getLogsDependsOnStudentSurname() {
    List<Person> persons = ObjectBox.store
        .box<Person>()
        .query(
            Person_.surname.contains(_input)..and(Person_.personType.equals(2)))
        .build()
        .find();

    setState(() {
      _logs.clear();

      for (var person in persons) {
        List<Log> personLogs = ObjectBox.store
            .box<Log>()
            .query(Log_.modelType.equals(ModelType.account.index)
              ..and(Log_.participatingClassId
                  .equals(person.student.target!.account.target!.id)))
            .build()
            .find();
        for (var element in personLogs) {
          if (element.participatingClassId ==
              person.student.target!.account.targetId) {
            _logs.add(element);
          }
        }
      }
      _logs
          .sort((firsLog, secondLog) => firsLog.date.compareTo(secondLog.date));
    });
  }
}
