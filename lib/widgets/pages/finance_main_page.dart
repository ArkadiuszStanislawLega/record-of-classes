import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  static const double titleHeight = 200.0;
  late Store _store;
  late Stream<List<Bill>> _billsStream;
  bool _isPaidFilter = false;
  final List<Bill> _unpaid = [], _paid = [];
  double _unpaidPrice = 0.0, _paidPrice = 0.0;

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
                icon: _isPaidFilter
                    ? Icons.filter_alt
                    : Icons.filter_alt_outlined,
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
              child: const Text(
                Strings.MANAGE_FINANCES,
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            _oneRow('${Strings.PAID_CLASSES}:', _paid.length.toString()),
            _oneRow('${Strings.UNPAID_CLASSES}:', _unpaid.length.toString()),
            _oneRow('${Strings.TOTAL_PAID}:',
                '${_paidPrice.toStringAsFixed(2)} ${Strings.CURRENCY}'),
            _oneRow('${Strings.TOTAL_UNPAID}:',
                '${_unpaidPrice.toStringAsFixed(2)} ${Strings.CURRENCY}'),
          ],
        ),
      ),
    );
  }

  SliverList _pageNavigator() =>
      _isPaidFilter ? _unpaidSliverList() : _paidSliverList();

  SliverList _unpaidSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) =>
            BillListItem(bill: _unpaid.elementAt(index)),
        childCount: _unpaid.length,
      ),
    );
  }

  SliverList _paidSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) =>
            BillListItem(bill: _paid.elementAt(index)),
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
    setState(() {
      if (_isPaidFilter) {
        _isPaidFilter = false;
      } else {
        _isPaidFilter = true;
      }
    });
  }
}
