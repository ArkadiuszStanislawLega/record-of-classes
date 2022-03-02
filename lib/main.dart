import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/address.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/models/teacher.dart';
import 'package:record_of_classes/objectbox.g.dart';
import 'package:record_of_classes/widgets/pages/about_page.dart';
import 'package:record_of_classes/widgets/pages/add/add_classes_to_group_template.dart';
import 'package:record_of_classes/widgets/pages/add/add_phone_to_student.dart';
import 'package:record_of_classes/widgets/pages/add/add_siblings_to_student_page.dart';
import 'package:record_of_classes/widgets/pages/add/add_student_to_group_page.dart';
import 'package:record_of_classes/widgets/pages/classes_main_page.dart';
import 'package:record_of_classes/widgets/pages/classes_type_main_page.dart';
import 'package:record_of_classes/widgets/pages/create/create_classes_type.dart';
import 'package:record_of_classes/widgets/pages/create/create_group_page.dart';
import 'package:record_of_classes/widgets/pages/add/add_parent_page.dart';
import 'package:record_of_classes/widgets/pages/create/create_parent_page.dart';
import 'package:record_of_classes/widgets/pages/create/create_phone_page.dart';
import 'package:record_of_classes/widgets/pages/create/create_student_page.dart';
import 'package:record_of_classes/widgets/pages/manage_database_page.dart';
import 'package:record_of_classes/widgets/pages/record_of_classes_tree_view_page.dart';
import 'package:record_of_classes/widgets/pages/detail/classes_type_detail_page.dart';
import 'package:record_of_classes/widgets/pages/detail/group_detail_page.dart';
import 'package:record_of_classes/widgets/pages/detail/parent_detail_page.dart';
import 'package:record_of_classes/widgets/pages/edit/edit_classes_type_page.dart';
import 'package:record_of_classes/widgets/pages/edit/edit_group_page.dart';
import 'package:record_of_classes/widgets/pages/edit/edit_parent_page.dart';
import 'package:record_of_classes/widgets/pages/edit/edit_phone_page.dart';
import 'package:record_of_classes/widgets/pages/edit/edit_student_page.dart';
import 'package:record_of_classes/widgets/pages/finance_main_page.dart';
import 'package:record_of_classes/widgets/pages/fund_account_page.dart';
import 'package:record_of_classes/widgets/pages/groups_main_page.dart';
import 'package:record_of_classes/widgets/pages/phone_book_page.dart';
import 'package:record_of_classes/widgets/pages/start_page.dart';
import 'package:record_of_classes/widgets/pages/detail/student_detail_page.dart';
import 'package:record_of_classes/widgets/pages/students_main_page.dart';
import 'package:record_of_classes/widgets/test.dart';

import 'models/person.dart';

import 'models/phone.dart';
import 'widgets/pages/detail/classes_detail_page.dart';

class ObjectBox {
  /// The Store of this app.
  static late final Store store;

  ObjectBox._create(store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    await getApplicationDocumentsDirectory().then((dir) {
      ObjectBox.store = Store(
        getObjectBoxModel(),
        directory: '${dir.path}/${AppStrings.DATABASE_DIRECTORY}',
      );
    });
    return ObjectBox._create(store);
  }

  void open(){
    store.syncClient();
  }
}

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  // clearDb();
  _putTeacherToDb();
  printDataFromDB();
  // objectBox.store.box<Account>().getAll().forEach((element) {
  //   print(element.id);
  // });
  runApp(const RecordOfClassesApp());
}

void _putTeacherToDb() {
  var teacherObjectBox = ObjectBox.store.box<Teacher>();
  var teachers = teacherObjectBox.getAll();
  if (teachers.isEmpty) {
    var person = Person(name: 'Monika', surname: 'Łęga')
      ..dbPersonType = PersonType.teacher.index;
    var teacher = Teacher()..person.target = person;
    teacherObjectBox.put(teacher);
  }
}

void clearDb() {
  ObjectBox.store.box<Account>().removeAll();
  ObjectBox.store.box<Address>().removeAll();
  ObjectBox.store.box<Attendance>().removeAll();
  ObjectBox.store.box<Bill>().removeAll();
  ObjectBox.store.box<Classes>().removeAll();
  ObjectBox.store.box<ClassesType>().removeAll();
  ObjectBox.store.box<Group>().removeAll();
  ObjectBox.store.box<Parent>().removeAll();
  ObjectBox.store.box<Person>().removeAll();
  ObjectBox.store.box<Phone>().removeAll();
  ObjectBox.store.box<Student>().removeAll();
  ObjectBox.store.box<Teacher>().removeAll();
}

void printDataFromDB() {
  print('Persons:');
  ObjectBox.store.box<Person>().getAll().forEach((element) {
    print(element.toString());

    print('Students:');
    ObjectBox.store.box<Student>().getAll().forEach((element) {
      print(element.toString());
      print('rodzice: ${element.parents.length.toString()}');
      for (var parent in element.parents) {
        parent.person.target.toString();
      }
    });
  });
  print('Parents');
  ObjectBox.store.box<Parent>().getAll().forEach((element) {
    print('${element.toString()} ${element.person.target.toString()}');
    print('dzieci:');
    element.children.forEach((children) {
      print(children.toString());
    });
  });

  print('Phones');
  ObjectBox.store.box<Phone>().getAll().forEach((element) {
    print(
        '${element.owner.target!.introduceYourself()} ${element.numberName} ${element.number}');
  });

  print('Accounts');
  ObjectBox.store.box<Account>().getAll().forEach((element) {
    print(element.toString());
  });

  print('Classes');
  ObjectBox.store.box<Classes>().getAll().forEach((element) {
    print(element.toString());
  });

  print('Grups');
  ObjectBox.store.box<Group>().getAll().forEach((element) {
    print(element.toString());
  });

  print('ClassesType');
  ObjectBox.store.box<ClassesType>().getAll().forEach((element) {
    print(element.toString());
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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.green.shade900,
        primarySwatch: Colors.green,
        fontFamily: AppStrings.FONT_NEW_ATHENA_UNICODE,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        listTileTheme: ListTileThemeData(
          horizontalTitleGap: 2.0,
          tileColor: Colors.white60,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontFamily: AppStrings.FONT_LUCIAN_SCHOENSHRIFT,
              fontSize: 35.0,
              color: Colors.white),
          headline2: TextStyle(fontSize: 16.0, color: Colors.white),
          headline3: TextStyle(
              fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(
              fontSize: 17.0, fontFamily: AppStrings.FONT_NEW_ATHENA_UNICODE),
        ),
      ),
      title: AppStrings.APP_TITLE,
      initialRoute: AppUrls.HOME,
      routes: {
        AppUrls.EMPTY: (context) => const StartPageView(),
        AppUrls.HOME: (context) => const StartPageView(),
        AppUrls.ABOUT: (context) => const AboutPage(),
        AppUrls.CREATE_STUDENT: (context) => CreateStudentPage(),
        AppUrls.DETAIL_STUDENT: (context) => const StudentDetailPage(),
        AppUrls.EDIT_STUDENT: (context) => EditStudentPage(),
        AppUrls.ADD_PARENT: (context) => const AddParentPage(),
        AppUrls.CREATE_PARENT: (context) => CreateParentPage(),
        AppUrls.DETAIL_PARENT: (context) => const ParentDetailPage(),
        AppUrls.EDIT_PARENT: (context) => const EditParentPage(),
        AppUrls.ADD_SIBLING: (context) => const AddSiblingsToStudentPage(),
        AppUrls.CREATE_CLASSES_TYPE: (context) => CreateClassesTypePage(),
        AppUrls.DETAIL_CLASSES_TYPE: (context) => DetailClassesType(),
        AppUrls.EDIT_CLASSES_TYPE: (context) => const EditClassesTypePage(),
        AppUrls.CREATE_GROUP: (context) => const CreateGroupPage(),
        AppUrls.EDIT_GROUP: (context) => const EditGroupPage(),
        AppUrls.DETAIL_GROUP: (context) => const DetailGroupPage(),
        AppUrls.ADD_STUDENT_TO_GROUP: (context) =>
            const AddStudentToGroupPage(),
        AppUrls.ADD_CLASSES_TO_GROUP: (context) => AddClassesToGroup(),
        AppUrls.ADD_CONTACT_TO_STUDENT: (context) => AddPhoneToStudentPage(),
        AppUrls.DETAIL_CLASSES: (context) => ClassesDetailPage(),
        AppUrls.STUDENS_MAIN_PAGE: (context) => const StudentsMainPage(),
        AppUrls.CLASSES_MAIN_PAGE: (context) => const ClassesMainPage(),
        AppUrls.CLASSES_TYPE_MAIN_PAGE: (context) =>
            const ClassesTypeMainPage(),
        AppUrls.FINANCE_MAIN_PAGE: (context) => const FinanceMainPage(),
        AppUrls.GROUPS_MAIN_PAGE: (context) => const GroupsMainPage(),
        AppUrls.ADD_PHONE: (context) => CreatePhonePage(),
        AppUrls.EDIT_PHONE: (context) => EditPhonePage(),
        AppUrls.PHONE_BOOK: (context) => const PhoneBookPage(),
        AppUrls.FUND_ACCOUNT: (context) => const FundAccountPage(),
        AppUrls.CREATE_CLASSES_NEW_VERSION: (context) =>
            RecordOfClassesTreeViewPage(),
        AppUrls.MANAGE_DATABASE: (context) => ManageDatabasePage(),
        '/test': (context) => Test()
      },
    );
  }
}

String formatTime(DateTime dateTime) {
  int hour = dateTime.hour, minutes = dateTime.minute;

  return '${hour < 10 ? '0$hour' : hour}:${minutes < 10 ? '0$minutes' : minutes}';
}

String formatDate(DateTime dateTime, {bool isTimeOn = false}) {
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

  return isTimeOn
      ? '$strDay.$strMonth.$strYear $strHour:$strMinute'
      : '$strDay.$strMonth.$strYear';
}
