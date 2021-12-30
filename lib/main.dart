import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/pages/create_student_page.dart';
import 'package:record_of_classes/widgets/pages/start_page.dart';
import 'package:record_of_classes/widgets/pages/student_detail_page.dart';

import 'models/person.dart';

import 'objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }
}

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();

  // objectBox.store.box<Student>().removeAll();
  // objectBox.store.box<Person>().removeAll();
  objectBox.store.box<Person>().getAll().forEach((element) {
    print(element.toString());
  });
  objectBox.store.box<Student>().getAll().forEach((element) {
    print(element.toString());
  });

  runApp(const RecordOfClassesApp());
}

class RecordOfClassesApp extends StatefulWidget {
  const RecordOfClassesApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecordOfClassesApp();
  }
}

class _RecordOfClassesApp extends State<RecordOfClassesApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rejestr zajęć',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      initialRoute: AppUrls.HOME,
      routes: {
        AppUrls.EMPTY: (context) => const StartPageView(),
        AppUrls.HOME: (context) => const StartPageView(),
        AppUrls.CREATE_STUDENT: (context) => const CreateStudentPage(),
        AppUrls.DETAIL_STUDENT: (context) => const StudentDetailPage(),
      },
    );
  }
}
