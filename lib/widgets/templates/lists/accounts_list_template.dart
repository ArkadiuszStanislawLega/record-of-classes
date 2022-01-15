import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/list_items/bill_list_item.dart';

class AccountListTemplate extends StatefulWidget {
  const AccountListTemplate({Key? key, required this.account})
      : super(key: key);

  final ToOne<Account> account;

  @override
  State<StatefulWidget> createState() {
    return _AccountListTemplate();
  }
}

class _AccountListTemplate extends State<AccountListTemplate> {
  late Store _store;
  late Stream<List<Bill>> _billsStream;
  late ToOne<Account> account;
  late ToOne<Group> group;

  double _priceToPay = 0.0, _payed = 0.0;

  @override
  Widget build(BuildContext context) {
    account = widget.account;

    return SizedBox(
      child: StreamBuilder<List<Bill>>(
        stream: _billsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _preparePriceToPay();
            var bills = widget.account.target!.bills;
            bills.sort((bill, bill2) => bill.isPaid != bill2.isPaid ? 1 :0);
            return Column(
              children: [
                Text('${Strings.TO_PAY}: $_priceToPay'),
                Text('${Strings.PAID}: $_payed'),
                ListView.builder(
                  itemCount: account.target!.bills.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return BillListItem(bill: account.target!.bills.elementAt(index));
                  },
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

    void _preparePriceToPay() {
    _priceToPay = 0.0;
    _payed = 0.0;
    for (var bill in account.target!.bills) {
      if (!bill.isPaid) {
        _priceToPay += bill.price;
      } else{
        _payed += bill.price;
      }
    }
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
