import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/models/teacher.dart';
import 'package:record_of_classes/objectbox.g.dart';
import 'package:record_of_classes/widgets/pages/add/add_classes_to_group_template.dart';
import 'package:record_of_classes/widgets/pages/add/add_siblings_to_student_page.dart';
import 'package:record_of_classes/widgets/pages/add/add_student_to_group_page.dart';
import 'package:record_of_classes/widgets/pages/classes_main_page.dart';
import 'package:record_of_classes/widgets/pages/classes_type_main_page.dart';
import 'package:record_of_classes/widgets/pages/create/create_group_page.dart';
import 'package:record_of_classes/widgets/pages/create/create_parent_page.dart';
import 'package:record_of_classes/widgets/pages/detail/classes_type_detail_page.dart';
import 'package:record_of_classes/widgets/pages/detail/group_detail_page.dart';
import 'package:record_of_classes/widgets/pages/detail/parent_detail_page.dart';
import 'package:record_of_classes/widgets/pages/finance_main_page.dart';
import 'package:record_of_classes/widgets/pages/groups_main_page.dart';
import 'package:record_of_classes/widgets/pages/start_page.dart';
import 'package:record_of_classes/widgets/pages/detail/student_detail_page.dart';
import 'package:record_of_classes/widgets/pages/students_main_page.dart';
import 'package:record_of_classes/widgets/test.dart';

import 'models/person.dart';

import 'models/phone.dart';
import 'widgets/pages/detail/classes_detail_page.dart';

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
  _putTeacherToDb();
  // clearDb();
  // clearDb();
  // printDataFromDB();
  // objectBox.store.box<Account>().getAll().forEach((element) {
  //   print(element.id);
  // });
  runApp(const RecordOfClassesApp());
}

void _putTeacherToDb() {
  var teacherObjectBox = objectBox.store.box<Teacher>();
  var teachers = teacherObjectBox.getAll();
  if (teachers.isEmpty) {
    var person = Person(name: 'Monika', surname: 'Łęga');
    var teacher = Teacher()..person.target = person;
    teacherObjectBox.put(teacher);
    print('Dodano nauczyciela ${teacherObjectBox.get(1)}');
  }
}

void clearDb() {
  objectBox.store.box<Person>().removeAll();
  objectBox.store.box<Student>().removeAll();
  objectBox.store.box<Parent>().removeAll();
  objectBox.store.box<Account>().removeAll();
  objectBox.store.box<Phone>().removeAll();
  objectBox.store.box<Group>().removeAll();
  objectBox.store.box<Classes>().removeAll();
  objectBox.store.box<ClassesType>().removeAll();
  objectBox.store.box<Bill>().removeAll();
}

void printDataFromDB() {
  print('Persons:');
  objectBox.store.box<Person>().getAll().forEach((element) {
    print(element.toString());

    print('Students:');
    objectBox.store.box<Student>().getAll().forEach((element) {
      print(element.toString());
      print('rodzice: ${element.parents.length.toString()}');
      for (var parent in element.parents) {
        parent.person.target.toString();
      }
    });
  });
  print('Parents');
  objectBox.store.box<Parent>().getAll().forEach((element) {
    print('${element.toString()} ${element.person.target.toString()}');
    print('dzieci:');
    element.children.forEach((children) {
      print(children.toString());
    });
    print('kontakty:');
    element.phone.forEach((phone) {
      print(phone.toString());
    });
  });
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
        AppUrls.DETAIL_STUDENT: (context) => const StudentDetailPage(),
        AppUrls.CREATE_PARENT: (context) => const CreateParentPage(),
        AppUrls.DETAIL_PARENT: (context) => const ParentDetailPage(),
        AppUrls.ADD_SIBLING: (context) => const AddSiblingsToStudentPage(),
        AppUrls.DETAIL_CLASSES_TYPE: (context) => DetailClassesType(),
        AppUrls.CREATE_GROUP: (context) => const CreateGroupPage(),
        AppUrls.DETAIL_GROUP: (context) => const DetailGroupPage(),
        AppUrls.ADD_STUDENT_TO_GROUP: (context) => const AddStudentToGroupPage(),
        AppUrls.ADD_CLASSES_TO_GROUP: (context) => AddClassesToGroup(),
        AppUrls.DETAIL_CLASSES: (context) => ClassesDetailPage(),
        AppUrls.STUDENS_MAIN_PAGE: (context) => const StudentsMainPage(),
        AppUrls.CLASSES_MAIN_PAGE: (context) => const ClassesMainPage(),
        AppUrls.CLASSES_TYPE_MAIN_PAGE: (context) => const ClassesTypeMainPage(),
        AppUrls.FINANCE_MAIN_PAGE: (context) => const FinanceMainPage(),
        AppUrls.GROUPS_MAIN_PAGE: (context) => const GroupsMainPage(),
        '/test' : (context) => Test()
      },
    );
  }
}


String FormatDate(DateTime dateTime) {
  int day = dateTime.day,
      month = dateTime.month,
      year = dateTime.year,
      hour = dateTime.hour,
      minute = dateTime.minute;

  String strDay = day < 10 ? '0$day' : day.toString(),
      strMonth = month < 10 ? '0$month' : month.toString(),
      strYear = year.toString(),
      strHour = hour.toString(),
      strMinute = minute == 0 ? '${minute}0' : minute.toString();

  return '$strDay.$strMonth.$strYear $strHour:$strMinute';
}
