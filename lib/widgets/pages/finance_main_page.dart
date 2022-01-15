import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/widgets/templates/lists/all_unpaid_bills_list_template.dart';

class FinanceMainPage extends StatefulWidget {
  const FinanceMainPage({Key? key}) : super(key: key);

  @override
  _FinanceMainPageState createState() => _FinanceMainPageState();
}

class _FinanceMainPageState extends State<FinanceMainPage> {
  late Store _store;
  late Stream<List<Bill>> _billsStream;
  bool _isPaidFilter = false;
  late List<Bill> _unpaid = [], _paid = [];
  double _unpaidPrice = 0.0, _paidPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: _onPressChangeFiltering, icon: const Icon(Icons.filter_alt_outlined)),
          ],
          title: const Text(Strings.FINANCE),
          bottom: const TabBar(
            tabs: [Tab(text: 'Statystyki'), Tab(text: 'List rachunków')],
          ),
        ),
        body: StreamBuilder<List<Bill>>(
          stream: _billsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _prepareData(snapshot.data!);
              return _view();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void _prepareData(List<Bill> list) {
    _paid.clear();
    _unpaid.clear();
    _paidPrice = 0.0;
    _unpaidPrice = 0.0;

    for (var bill in list) {
      if (bill.isPaid) {
        _paid.add(bill);
        _paidPrice += bill.price;
      } else {
        _unpaid.add(bill);
        _unpaidPrice += bill.price;
      }
      ;
    }
  }

  Widget _view() {
    return TabBarView(
      children: [
        Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _oneRow('${Strings.PAID_CLASSES}:', _paid.length.toString()),
                  _oneRow(
                      '${Strings.UNPAID_CLASSES}:', _unpaid.length.toString()),
                  _oneRow('${Strings.TOTAL_PAID}:',
                      '${_paidPrice.toStringAsFixed(2)} ${Strings.CURRENCY}'),
                  _oneRow('${Strings.TOTAL_UNPAID}:',
                      '${_unpaidPrice.toStringAsFixed(2)} ${Strings.CURRENCY}'),
                ],
              ),
            ),

          ],
        ),
        AllUnpaidBillsTemplate(bills: _isPaidFilter ? _paid : _unpaid),
      ],
    );
  }

  Widget _oneRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value),
      ],
    );
  }

  void _onPressChangeFiltering() {
    setState(() {
      if (_isPaidFilter) {
        _isPaidFilter = false;
      } else {
        _isPaidFilter = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _billsStream = _store
        .box<Bill>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
