import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
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
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: Strings.PAID,
          color: Colors.green,
          icon: Icons.check,
          onTap: _setIsPaidInDatabase
        ),
        IconSlideAction(
            caption: Strings.UNPAID,
            color: Colors.orange,
            icon: Icons.close_outlined,
            onTap: _setIsUnpaidInDatabase
        ),
      ],
      child: ListTile(
        title: Text(widget.bill.classes.target!.group.target!.name),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.bill.price.toString()}zł'),
            Icon(widget.bill.isPaid ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                color: widget.bill.isPaid ? Colors.green : Colors.black),
          ],
        ),
      ),
    );

  }

  void _setIsPaidInDatabase(){
    setState(() {
      Store store = objectBox.store;
      widget.bill.isPaid = true;
      store.box<Bill>().put(widget.bill);
    });
  }

  void _setIsUnpaidInDatabase(){
    setState(() {
      Store store = objectBox.store;
      widget.bill.isPaid = false;
      store.box<Bill>().put(widget.bill);
    });
  }
}
