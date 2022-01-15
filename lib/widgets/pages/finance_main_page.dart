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
  bool _isPaiedFilter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.FINANCE),
      ),
      body: StreamBuilder<List<Bill>>(
        stream: _billsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var unpaid =
                snapshot.data!.skipWhile((value) => value.isPaid).toList();
            var paid =
                snapshot.data!.skipWhile((value) => !value.isPaid).toList();
            return Column(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_isPaiedFilter) {
                        _isPaiedFilter = false;
                      } else {
                        _isPaiedFilter = true;
                      }
                    });
                  },
                  child: Text('Zmień'),
                ),
                Text('Zapłaconych zajęć: ${paid.length.toString()}'),
                Text('Nie zapłaconych zajęć: ${unpaid.length.toString()}'),
                AllUnpaidBillsTemplate(bills: _isPaiedFilter ? paid : unpaid),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
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
