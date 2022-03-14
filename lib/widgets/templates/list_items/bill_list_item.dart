import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/bill.dart';

class BillListItem extends StatefulWidget {
  BillListItem(
      {Key? key,
      required this.bill,
      required this.payBill,
      required this.withdrawThePaymentOfTheBill})
      : super(key: key);
  final Bill bill; //withdraw
  late Function payBill, withdrawThePaymentOfTheBill;

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
        !widget.bill.isPaid
            ? IconSlideAction(
                caption: AppStrings.paid,
                color: Colors.green,
                icon: Icons.check,
                onTap: _setIsPaidInDatabase)
            : IconSlideAction(
                caption: AppStrings.unpaid,
                color: Colors.orange,
                icon: Icons.close_outlined,
                onTap: _setIsUnpaidInDatabase),
      ],
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 7,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.bill.studentAccount.target!.student.target!
                  .introduceYourself()),
              Text(formatDate(
                  widget.bill.attendance.target!.classes.target!.dateTime,
                  isWeekDayVisible: true))
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      widget.bill.attendance.target!.classes.target!.group
                          .target!.name,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Text('${widget.bill.price.toString()}${AppStrings.currency}'),
                ],
              ),
              Icon(
                  widget.bill.isPaid
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank,
                  color: widget.bill.isPaid ? Colors.green : Colors.black),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, AppUrls.detailStudent, arguments: {
              AppStrings.student:
                  widget.bill.studentAccount.target!.student.target!
            });
          },
        ),
      ),
    );
  }

  void _setIsPaidInDatabase() => widget.payBill(widget.bill);

  void _setIsUnpaidInDatabase() =>
      widget.withdrawThePaymentOfTheBill(widget.bill);
}
