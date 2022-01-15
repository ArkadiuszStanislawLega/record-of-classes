import 'package:flutter/material.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/widgets/templates/list_items/bill_list_item.dart';

class AllUnpaidBillsTemplate extends StatefulWidget {
  AllUnpaidBillsTemplate({Key? key, required this.bills}) : super(key: key);

  late List<Bill> bills;

  @override
  _AllUnpaidBillsTemplateState createState() => _AllUnpaidBillsTemplateState();
}

class _AllUnpaidBillsTemplateState extends State<AllUnpaidBillsTemplate> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.bills.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return BillListItem(bill: widget.bills.elementAt(index));
      },
    );
  }
}
