import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/widgets/templates/lists/all_classes_list_template.dart';

class ClassesMainPage extends StatefulWidget {
  const ClassesMainPage({Key? key}) : super(key: key);

  @override
  _ClassesMainPageState createState() => _ClassesMainPageState();
}

class _ClassesMainPageState extends State<ClassesMainPage> {
  late Store _store;
  late Stream<List<Classes>> _classesStream;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.CLASSES),),
      body: StreamBuilder<List<Classes>>(
        stream: _classesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text('${Strings.NUMBER_OF_CLASSES}: ${snapshot.data!.length}'),
                  AllClassesListTemplate(classes: snapshot.data!),
                ],
              ),
            );
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
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
