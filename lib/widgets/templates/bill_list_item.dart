import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/models/bill.dart';

class BillListItem extends StatefulWidget {
  const BillListItem({Key? key, required this.bill}) : super(key: key);
  final Bill bill;

  @override
  State<StatefulWidget> createState() {
    return _BillListItem();
  }
}

class _BillListItem extends State<BillListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('${widget.bill.price.toString()}zł'),
            Icon(
                widget.bill.isPaid
                    ? Icons.check
                    : Icons.check_box_outline_blank,
                color: widget.bill.isPaid ? Colors.green : Colors.black),
          ],
        ),
        Text(widget.bill.classes.target!.group.target!.name),
      ],
    );
  }
}
