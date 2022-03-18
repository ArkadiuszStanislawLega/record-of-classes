import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/models/account.dart';

class GroupedBillsListItem extends StatefulWidget {
  GroupedBillsListItem({Key? key, required this.account}) : super(key: key);

  Account account;

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
        title: Text(widget.account.student.target!.introduceYourself()),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                    '${widget.account.countUnpaidBillsPrice().toString()}${AppStrings.currency}'),
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
