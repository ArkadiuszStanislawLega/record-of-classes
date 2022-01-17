import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/list_items/bill_list_item.dart';
import 'package:record_of_classes/widgets/templates/list_items/parent_of_student_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/list_items/remove_sibling_list_item.dart';
import 'package:record_of_classes/widgets/templates/list_items/student_attendances_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentDetailPage();
  }
}

enum Pages { parents, siblings, account, attendance }

class _StudentDetailPage extends State<StudentDetailPage> {
  late Student _student;
  late Store _store;
  late Stream<List<Student>> _parentsStream;
  Pages _currentPage = Pages.parents;

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _parentsStream = _store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Widget build(BuildContext context) {
    _student = ModalRoute.of(context)!.settings.arguments as Student;
    return StreamBuilder<List<Student>>(
      stream: _parentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _student = objectBox.store.box<Student>().get(_student.id)!;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  _customAppBar(),
                  _content(),
                ],
              ),
              floatingActionButton: SpeedDial(
                icon: Icons.add,
                backgroundColor: Colors.amber,
                children: [
                  SpeedDialChild(
                      child: const Icon(Icons.person),
                      label: Strings.ADD_SIBLING,
                      backgroundColor: Colors.amberAccent,
                      onTap: _navigateToAddSiblings),
                  SpeedDialChild(
                      child: const Icon(Icons.group),
                      label: Strings.ADD_PARENT,
                      backgroundColor: Colors.amberAccent,
                      onTap: _navigateToCreateParent),
                  SpeedDialChild(
                      child: const Icon(Icons.edit),
                      label: Strings.EDIT,
                      backgroundColor: Colors.amberAccent,
                      onTap: _navigateToEditStudent),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _navigateToEditStudent() =>
      Navigator.pushNamed(context, AppUrls.EDIT_STUDENT, arguments: _student);

  void _navigateToAddSiblings() =>
      Navigator.pushNamed(context, AppUrls.ADD_SIBLING, arguments: _student);

  void _navigateToCreateParent() =>
      Navigator.pushNamed(context, AppUrls.CREATE_PARENT, arguments: _student);

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: const Size(0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _pageNavigationButton(title: Strings.PARENTS, page: Pages.parents),
            _pageNavigationButton(
                title: Strings.SIBLINGS, page: Pages.siblings),
            _pageNavigationButton(title: Strings.BILLS, page: Pages.account),
            _pageNavigationButton(
                title: Strings.ATTENDANCES, page: Pages.attendance),
          ],
        ),
      ),
      stretch: true,
      onStretchTrigger: () => Future<void>.value(),
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _propertiesView(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.5),
                  end: Alignment.center,
                  colors: <Color>[Colors.black12, Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DecoratedBox _pageNavigationButton(
      {required String title, required Pages page}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: _currentPage == page ? Colors.black12 : Colors.transparent,
            offset: const Offset(0, -1),
            blurRadius: 4,
          )
        ],
      ),
      child: TextButton(
        onPressed: () => setState(() => _currentPage = page),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  SliverList _content() => _pageNavigator();

  SliverList _pageNavigator() {
    switch (_currentPage) {
      case Pages.parents:
        return _parentsSliverList();
      case Pages.account:
        return _accountSliverList();
      case Pages.siblings:
        return _siblingsSliverList();
      case Pages.attendance:
        return _attendancesSliverList();
    }
  }

  SliverList _parentsSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => ParentOfStudentListItemTemplate(
          parent: _student.parents.elementAt(index),
          student: _student,
        ),
        childCount: _student.parents.length,
      ),
    );
  }

  SliverList _siblingsSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => RemoveSiblingListItem(
            sibling: _student.siblings.elementAt(index), student: _student),
        childCount: _student.siblings.length,
      ),
    );
  }

  SliverList _accountSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) =>
            BillListItem(bill: _student.account.target!.bills.elementAt(index)),
        childCount: _student.account.target!.bills.length,
      ),
    );
  }

  SliverList _attendancesSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => StudentAttendancesListItemTemplate(
            attendance: _student.attendancesList.elementAt(index)),
        childCount: _student.attendancesList.length,
      ),
    );
  }

  SafeArea _propertiesView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: _propertiesNavigator(),
      ),
    );
  }

  Column _propertiesNavigator() {
    switch (_currentPage) {
      case Pages.parents:
        return _propertiesParents();
      case Pages.account:
        return _propertiesAccount();
      case Pages.siblings:
        return _propertiesSiblings();
      case Pages.attendance:
        return _propertiesAttendances();
    }
  }

  Column _pageTitle() {
    return Column(
      children: [
        Text(
          _student.introduceYourself(),
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        Text(
          '${Strings.AGE}: ${_student.age.toString()} ${Strings.YEARS}',
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }

  Column _propertiesParents() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: _pageTitle(),
        ),
      ],
    );
  }

  Column _propertiesSiblings() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: _pageTitle(),
        ),
        OneRowPropertyTemplate(
          title: '${Strings.NUMBER_OF_SIBLINGS}:',
          value: _student.siblings.length.toString(),
        ),
      ],
    );
  }

  Column _propertiesAccount() {
    double _toPay = 0.0, _paid = 0.0;
    for (var bill in _student.account.target!.bills) {
      bill.isPaid ? _paid += bill.price : _toPay += bill.price;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: _pageTitle(),
        ),
        OneRowPropertyTemplate(
          title: '${Strings.TO_PAY}:',
          value: '$_toPay${Strings.CURRENCY}',
        ),
        OneRowPropertyTemplate(
          title: '${Strings.PAID}:',
          value: '$_paid${Strings.CURRENCY}',
        ),
      ],
    );
  }

  Column _propertiesAttendances() {
    int numberOfAttendances = 0;
    for (Attendance attendance in _student.attendancesList) {
      if (attendance.isPresent) {
        numberOfAttendances++;
      }
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: _pageTitle(),
        ),
        OneRowPropertyTemplate(
          title: '${Strings.NUMBER_OF_ATTENDANCES}:',
          value: '$numberOfAttendances',
        ),
      ],
    );
  }

  void addParent() {
    Navigator.pushNamed(context, AppUrls.CREATE_PARENT, arguments: _student);
  }

  void addSibling() {
    Navigator.pushNamed(context, AppUrls.ADD_SIBLING, arguments: _student);
  }
}
