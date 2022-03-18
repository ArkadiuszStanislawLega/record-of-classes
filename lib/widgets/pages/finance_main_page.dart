import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/widgets/templates/list_items/bill_list_item.dart';
import 'package:record_of_classes/widgets/templates/list_items/grouped_bills_list_item.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class FinanceMainPage extends StatefulWidget {
  const FinanceMainPage({Key? key}) : super(key: key);

  @override
  _FinanceMainPageState createState() => _FinanceMainPageState();
}

enum BillListType { single, group }

class _FinanceMainPageState extends State<FinanceMainPage> {
  static const double titleHeight = 240.0;
  late Stream<List<Bill>> _billsStream;

  final List<Bill> _unpaid = [], _paid = [];
  double _unpaidPrice = 0.0, _paidPrice = 0.0;
  bool _isNotPaidFilter = true;
  BillListType _currentTypeListSelected = BillListType.group;

  @override
  void initState() {
    super.initState();
    _billsStream = ObjectBox.store
        .box<Bill>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Bill>>(
      stream: _billsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _prepareData(snapshot.data!);
          return Scaffold(
              body: CustomScrollView(
                slivers: [
                  _customAppBar(),
                  _content(),
                ],
              ),
              floatingActionButton:
                  _currentTypeListSelected == BillListType.single
                      ? SpeedDial(
                          icon: _isNotPaidFilter
                              ? Icons.filter_alt_outlined
                              : Icons.filter_alt,
                          backgroundColor: Colors.amber,
                          onPress: _onPressChangeFiltering,
                        )
                      : const SizedBox());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: const Size(0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: _switchToSingle,
              child: _pageNavigationButton(
                  billListType: BillListType.single, title: AppStrings.single),
            ),
            TextButton(
              onPressed: _switchToGrouped,
              child: _pageNavigationButton(
                  billListType: BillListType.group, title: AppStrings.grouping),
            )
          ],
        ),
      ),
      stretch: true,
      onStretchTrigger: () => Future<void>.value(),
      expandedHeight: titleHeight,
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
      {required BillListType billListType, required String title}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 9,
            color: _currentTypeListSelected == billListType
                ? Colors.black12
                : Colors.transparent,
            offset: const Offset(0, -1),
            blurRadius: 4,
          )
        ],
      ),
      child: Text(
        title,
        style: _currentTypeListSelected == billListType
            ? Theme.of(context).textTheme.headline2
            : Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  void _switchToGrouped() {
    setState(() {
      _currentTypeListSelected = BillListType.group;
    });
  }

  void _switchToSingle() {
    setState(() {
      _currentTypeListSelected = BillListType.single;
    });
  }

  SliverList _content() => _pageNavigator();

  void _prepareData(List<Bill> bills) {
    _paid.clear();
    _unpaid.clear();
    _paidPrice = 0.0;
    _unpaidPrice = 0.0;

    for (var bill in bills) {
      if (bill.isPaid) {
        _paid.add(bill);
        _paidPrice += bill.price;
      } else {
        _unpaid.add(bill);
        _unpaidPrice += bill.price;
      }
    }
  }

  SafeArea _propertiesView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                AppStrings.manageFinances,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            OneRowPropertyTemplate(
                title: '${AppStrings.paidClasses}:',
                value: _paid.length.toString()),
            OneRowPropertyTemplate(
                title: '${AppStrings.unpaidClasses}:',
                value: _unpaid.length.toString()),
            OneRowPropertyTemplate(
                title: '${AppStrings.totalPaid}:',
                value:
                    '${_paidPrice.toStringAsFixed(2)} ${AppStrings.currency}'),
            OneRowPropertyTemplate(
                title: '${AppStrings.totalUnpaid}:',
                value:
                    '${_unpaidPrice.toStringAsFixed(2)} ${AppStrings.currency}'),
          ],
        ),
      ),
    );
  }

  SliverList _pageNavigator() {
    if (_currentTypeListSelected == BillListType.group) {
      return _groupedBills();
    }
    return _isNotPaidFilter ? _unpaidSliverList() : _paidSliverList();
  }

  SliverList _groupedBills() {
    List<Account> filteredAccounts = _getAccountWithUnpaidBills();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => GroupedBillsListItem(
          account: filteredAccounts.elementAt(index),
        ),
        childCount: filteredAccounts.length,
      ),
    );
  }

  List<Account> _getAccountWithUnpaidBills() {
    List<Account> filteredAccounts = [];
    List<Account> accounts = ObjectBox.store.box<Account>().getAll();
    for (var value in accounts) {
      if (value.countUnpaidBills() > 0) {
        filteredAccounts.add(value);
      }
    }
    filteredAccounts.sort((firstAccount, secondAccount) => firstAccount
        .student.target!.person.target!.surname
        .compareTo(secondAccount.student.target!.person.target!.surname));
    return filteredAccounts;
  }

  SliverList _unpaidSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => BillListItem(
          bill: _unpaid.elementAt(index),
          payBill: _payTheBill,
          withdrawThePaymentOfTheBill: _withdrawTheBill,
        ),
        childCount: _unpaid.length,
      ),
    );
  }

  void _payTheBill(Bill bill) {
    setState(() {
      if (!bill.isPaid) {
        bill.setIsPaidInDb();
        bill.studentAccount.target!.reduceBalance(bill.price);
      }
    });
  }

  void _withdrawTheBill(Bill bill) {
    setState(() {
      if (bill.isPaid) {
        bill.setIsUnpaidInDb();
        bill.studentAccount.target!.fundBalance(bill.price);
      }
    });
  }

  SliverList _paidSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => BillListItem(
          bill: _paid.elementAt(index),
          payBill: _payTheBill,
          withdrawThePaymentOfTheBill: _withdrawTheBill,
        ),
        childCount: _paid.length,
      ),
    );
  }

  void _onPressChangeFiltering() {
    setState(
      () {
        if (_isNotPaidFilter) {
          _isNotPaidFilter = false;
        } else {
          _isNotPaidFilter = true;
        }
      },
    );
  }
}
