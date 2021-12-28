import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/widgets/pages/create_student_page.dart';
import 'package:record_of_classes/widgets/pages/start_page.dart';

import 'models/person.dart';

import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }
}

late ObjectBox objectBox;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create();

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
    final personsBox = objectBox.store.box<Person>();

    var length = personsBox.getAll().length;
    var personFromDb = personsBox.get(length-1);

    print(personFromDb!.name);

    return MaterialApp(
      title: 'Rejestr zajęć' + personFromDb.name,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      initialRoute: AppUrls.HOME,
      routes: {
        AppUrls.EMPTY: (context) => const StartPageView(),
        AppUrls.HOME: (context) => const StartPageView(),
        AppUrls.CREATE_STUDENT: (context) => const CreateStudentPage()
      },
    );
  }
}
