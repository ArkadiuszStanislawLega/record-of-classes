import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/widgets/templates/list_items/bill_list_item.dart';

class AllUnpaidBillsTemplate extends StatefulWidget {
  const AllUnpaidBillsTemplate({Key? key}) : super(key: key);

  @override
  _AllUnpaidBillsTemplateState createState() => _AllUnpaidBillsTemplateState();
}

class _AllUnpaidBillsTemplateState extends State<AllUnpaidBillsTemplate> {
  late Store _store;
  late Stream<List<Bill>> _billsStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Bill>>(
      stream: _billsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var unpaied = snapshot.data?.skipWhile((value) => value.isPaid);
          return ListView.builder(
            itemCount: unpaied?.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return BillListItem(bill: unpaied!.elementAt(index));
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
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
