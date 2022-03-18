import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/phone.dart';
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
  Pages _currentPage = Pages.account;
  late Map _args;
  late Function? _updatingFunction;
  final double maxTitleHeight = 230.0;

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _student = _args[AppStrings.student];
    _updatingFunction = _args[AppStrings.function];
    _student.getFromDb();

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
              label: AppStrings.fundAccount,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToFundAccount),
          SpeedDialChild(
              child: const Icon(Icons.person),
              label: AppStrings.addSiblings,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToAddSiblings),
          SpeedDialChild(
              child: const Icon(Icons.group),
              label: AppStrings.addParent,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToAddParent),
          SpeedDialChild(
              child: const Icon(Icons.add_call),
              label: AppStrings.addContact,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToAddContact),
          SpeedDialChild(
              visible: _updatingFunction != null ? true : false,
              child: const Icon(Icons.edit),
              label: AppStrings.edit,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToEditStudent),
        ],
      ),
    );
  }

  void _navigateToEditStudent() =>
      Navigator.pushNamed(context, AppUrls.editStudent, arguments: {
        AppStrings.student: _student,
        AppStrings.function: _updateStudentInDbAfterEditing
      });

  void _updateStudentInDbAfterEditing(
      {required String name, required String surname, required int age}) {
    setState(() {
      Person updatingValuesPerson = Person()
        ..name = name
        ..surname = surname;
      Student updatingValuesStudent = Student(age: age)
        ..person.target = updatingValuesPerson;

      _updatingFunction!(_student, updatingValuesStudent);
    });
  }

  void _navigateToAddSiblings() =>
      Navigator.pushNamed(context, AppUrls.addSibling, arguments: {
        AppStrings.student: _student,
        AppStrings.function: _addSiblingToDb
      });

  void _navigateToAddParent() =>
      Navigator.pushNamed(context, AppUrls.addParent, arguments: {
        AppStrings.student: _student,
        AppStrings.addFunction: _addParentToStudentInDb,
        AppStrings.removeFunction: _removeParentFromDb
      });

  void _removeParentFromDb(Parent parent) {
    setState(() {
      _student.removeParentFromDb(parent);
    });
  }

  void _addParentToStudentInDb(Parent parent) {
    setState(() {
      _student.addParentToDb(parent);
    });
  }

  void _navigateToAddContact() =>
      Navigator.pushNamed(context, AppUrls.addContactToStudent, arguments: {
        AppStrings.student: _student,
        AppStrings.function: _addContact
      });

  void _addContact(Phone contact) {
    setState(() {
      _student.person.target!.addPhone(contact);
    });
  }

  void _navigateToFundAccount() {
    Navigator.pushNamed(context, AppUrls.fundAccount, arguments: {
      AppStrings.student: _student,
      AppStrings.function: _fundAccountUpdateDb
    });
  }

  void _fundAccountUpdateDb({required double value}) {
    setState(() {
      _student.fundAccountDb(value);
    });
  }

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: const Size(0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _pageNavigationButton(
                title: AppStrings.parents, page: Pages.parents),
            _pageNavigationButton(
                title: AppStrings.siblings, page: Pages.siblings),
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
      expandedHeight: maxTitleHeight,
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
          phone: _student.person.target!.phones.elementAt(index),
        ),
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
          removeFunction: _removeConnectionsWithParent,
        ),
        childCount: _student.parents.length,
      ),
    );
  }

  void _removeConnectionsWithParent(Parent parent) {
    setState(() {
      _student.removeSelectedParentRelation(parent);
    });
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
        (BuildContext context, int index) => BillListItem(
          bill: _student.account.target!.bills.elementAt(index),
          payBill: _payTheBill,
          withdrawThePaymentOfTheBill: _withdrawTheBill,
        ),
        childCount: _student.account.target!.bills.length,
      ),
    );
  }

  void _payTheBill(Bill bill) {
    setState(() {
      if (!bill.isPaid) {
        bill.setIsPaidInDb();
        _student.account.target!.reduceBalance(bill.price);
      }
    });
  }

  void _withdrawTheBill(Bill bill) {
    setState(() {
      if (bill.isPaid) {
        bill.setIsUnpaidInDb();
        _student.account.target!.fundBalance(bill.price);
      }
    });
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
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(
          '${AppStrings.age}: ${_student.age.toString()} ${AppStrings.years}',
          style: Theme.of(context).textTheme.headline2,
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
          title: '${AppStrings.numberOfSiblings}:',
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
          title: '${AppStrings.balance}:',
          value:
              '${_student.account.target!.balance.toStringAsFixed(2)}${AppStrings.currency}',
        ),
        OneRowPropertyTemplate(
          title: '${AppStrings.toPay}:',
          value: '${_toPay.toStringAsFixed(2)}${AppStrings.currency}',
        ),
        OneRowPropertyTemplate(
          title: '${AppStrings.paid}:',
          value: '${_paid.toStringAsFixed(2)}${AppStrings.currency}',
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
          title: '${AppStrings.numberOfAttendances}:',
          value: '$numberOfAttendances',
        ),
      ],
    );
  }

  void addParent() =>
      Navigator.pushNamed(context, AppUrls.createParent, arguments: _student);

  /// Function to send children.
  /// Updating siblings in database.
  void _addSiblingToDb({required Student sibling}) {
    setState(() {
      _student.siblings.add(sibling);
      sibling.siblings.add(_student);
      _student.addToDb();
      sibling.addToDb();
    });
  }
}
