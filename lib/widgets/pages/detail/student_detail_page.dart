import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/list_items/bill_list_item.dart';
import 'package:record_of_classes/widgets/templates/list_items/parent_of_student_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/list_items/phone_book_list_item_template.dart';
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

enum Pages { parents, siblings, account, attendance, phones }

class _StudentDetailPage extends State<StudentDetailPage> {
  late Student _student;
  Pages _currentPage = Pages.parents;

  @override
  Widget build(BuildContext context) {
    _student = ModalRoute.of(context)!.settings.arguments as Student;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _customAppBar(),
          _content(),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.settings,
        backgroundColor: Colors.amber,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.monetization_on),
              label: Strings.FUND_ACCOUNT,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToFundAccount),
          SpeedDialChild(
              child: const Icon(Icons.person),
              label: Strings.ADD_SIBLING,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToAddSiblings),
          SpeedDialChild(
              child: const Icon(Icons.group),
              label: Strings.ADD_PARENT,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToAddParent),
          SpeedDialChild(
              child: const Icon(Icons.add_call),
              label: Strings.ADD_CONTACT,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToAddContact),
          SpeedDialChild(
              child: const Icon(Icons.edit),
              label: Strings.EDIT,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToEditStudent),
        ],
      ),
    );
  }

  void _navigateToEditStudent() =>
      Navigator.pushNamed(context, AppUrls.EDIT_STUDENT, arguments: _student);

  void _navigateToAddSiblings() =>
      Navigator.pushNamed(context, AppUrls.ADD_SIBLING, arguments: _student);

  void _navigateToAddParent() =>
      Navigator.pushNamed(context, AppUrls.ADD_PARENT, arguments: _student);

  void _navigateToAddContact() =>
      Navigator.pushNamed(context, AppUrls.ADD_CONTACT_TO_STUDENT,
          arguments: _student);

  void _navigateToFundAccount() =>
      Navigator.pushNamed(context, AppUrls.FUND_ACCOUNT, arguments: _student);

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
            _pageNavigationIconButton(
                icon: const Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                ),
                page: Pages.account),
            _pageNavigationIconButton(
                icon: const Icon(Icons.check_box_rounded, color: Colors.white),
                page: Pages.attendance),
            _pageNavigationIconButton(
                icon: const Icon(Icons.phone, color: Colors.white),
                page: Pages.phones),
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

  DecoratedBox _pageNavigationIconButton(
      {required Icon icon, required Pages page}) {
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
      child: IconButton(
        icon: icon,
        onPressed: () => setState(() => _currentPage = page),
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
      case Pages.phones:
        return _phonesSliverList();
    }
  }

  SliverList _phonesSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => PhoneBookListItemTemplate(
            phone: _student.person.target!.phones.elementAt(index)),
        childCount: _student.person.target!.phones.length,
      ),
    );
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
      case Pages.phones:
        return _propertiesParents();
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
          title: '${Strings.BILANCE}:',
          value: '${_student.account.target!.balance.toStringAsFixed(2)}${Strings.CURRENCY}',
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
