import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/widgets/templates/list_items/bill_list_item.dart';
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
  final List<Bill> _unpaid = [], _paid = [];
  double _unpaidPrice = 0.0, _paidPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: StreamBuilder<List<Bill>>(
          stream: _billsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _prepareData(snapshot.data!);
              return CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: <Widget>[
                  SliverAppBar(
                    actions: [
                      IconButton(
                          onPressed: _onPressChangeFiltering,
                          icon: const Icon(Icons.filter_alt_outlined)),
                    ],
                    stretch: true,
                    onStretchTrigger: () {
                      // Function callback for stretch
                      return Future<void>.value();
                    },
                    expandedHeight: 200.0,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const <StretchMode>[
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                        StretchMode.fadeTitle,
                      ],
                      centerTitle: true,
                      title: const Text(Strings.FINANCE),
                      background: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          SafeArea(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _oneRow('${Strings.PAID_CLASSES}:',
                                      _paid.length.toString()),
                                  _oneRow('${Strings.UNPAID_CLASSES}:',
                                      _unpaid.length.toString()),
                                  _oneRow('${Strings.TOTAL_PAID}:',
                                      '${_paidPrice.toStringAsFixed(2)} ${Strings.CURRENCY}'),
                                  _oneRow('${Strings.TOTAL_UNPAID}:',
                                      '${_unpaidPrice.toStringAsFixed(2)} ${Strings.CURRENCY}'),
                                ],
                              ),
                            ),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.0, 0.5),
                                end: Alignment.center,
                                colors: <Color>[
                                  Colors.black12,
                                  Colors.transparent
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return BillListItem(
                            bill: _isPaidFilter
                                ? _paid.elementAt(index)
                                : _unpaid.elementAt(index));
                      },
                      childCount: _isPaidFilter
                          ? _paid.length
                          : _unpaid.length, // 1000 list items
                    ),
                  ),
                ],
              );
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
        Text(title, style: TextStyle(color: Colors.white),),
        Text(value, style: TextStyle(color: Colors.white),),
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
