import 'package:flutter/material.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/log.dart';
import 'package:record_of_classes/widgets/templates/list_items/log_list_item_template.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('log page'),
      ),
      body: Center(
        child: _list(),
      ),
    );
  }

  Widget _list() {
    List<Log> logs = ObjectBox.store.box<Log>().getAll();
    logs.sort((firstLog, secondLog) => firstLog.date.compareTo(secondLog.date) == 0 ? 0 : 1);
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: logs.length,
      itemBuilder: (BuildContext context, int index) {
        return LogListItemTemplate(log: logs[index]);
      },
    );
  }
}
