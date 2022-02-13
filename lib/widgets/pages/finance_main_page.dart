import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/widgets/templates/list_items/bill_list_item.dart';

class FinanceMainPage extends StatefulWidget {
  const FinanceMainPage({Key? key}) : super(key: key);

  @override
  _FinanceMainPageState createState() => _FinanceMainPageState();
}

class _FinanceMainPageState extends State<FinanceMainPage> {
  static const double titleHeight = 200.0;
  late Stream<List<Bill>> _billsStream;

  final List<Bill> _unpaid = [], _paid = [];
  double _unpaidPrice = 0.0, _paidPrice = 0.0;
  bool _isNotPaidFilter = true;

  @override
  void initState() {
    super.initState();
    _billsStream = objectBox.store
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
                icon: _isNotPaidFilter
                    ? Icons.filter_alt_outlined
                    : Icons.filter_alt,
                backgroundColor: Colors.amber,
                onPress: _onPressChangeFiltering,
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SliverAppBar _customAppBar() {
    return SliverAppBar(
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
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppStrings.MANAGE_FINANCES,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            _oneRow('${AppStrings.PAID_CLASSES}:', _paid.length.toString()),
            _oneRow('${AppStrings.UNPAID_CLASSES}:', _unpaid.length.toString()),
            _oneRow('${AppStrings.TOTAL_PAID}:',
                '${_paidPrice.toStringAsFixed(2)} ${AppStrings.CURRENCY}'),
            _oneRow('${AppStrings.TOTAL_UNPAID}:',
                '${_unpaidPrice.toStringAsFixed(2)} ${AppStrings.CURRENCY}'),
          ],
        ),
      ),
    );
  }

  SliverList _pageNavigator() =>
      _isNotPaidFilter ? _unpaidSliverList() : _paidSliverList();

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
        bill.studentAccount.target!.addValueToBalance(-bill.price);
      }
    });
  }

  void _withdrawTheBill(Bill bill) {
    setState(() {
      if (bill.isPaid) {
        bill.setIsUnpaidInDb();
        bill.studentAccount.target!.addValueToBalance(bill.price);
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

  Widget _oneRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
      ],
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
