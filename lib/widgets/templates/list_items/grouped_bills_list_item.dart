import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/models/account.dart';

class GroupedBillsListItem extends StatefulWidget {
  const GroupedBillsListItem({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  State<GroupedBillsListItem> createState() => _GroupedBillsListItemState();
}

class _GroupedBillsListItemState extends State<GroupedBillsListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 7,
      child: ListTile(
        title: Text(widget.account.student.target!.introduceYourself(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('${AppStrings.toPay}:'),
                Text(
                  '${widget.account.countUnpaidBillsPrice().toString()}${AppStrings.currency}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('${AppStrings.unpaidClasses}: '),
                Text(
                  '${widget.account.countUnpaidBills()} ${AppStrings.pcs}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, AppUrls.detailStudent,
              arguments: {AppStrings.student: widget.account.student.target!});
        },
      ),
    );
  }
}
