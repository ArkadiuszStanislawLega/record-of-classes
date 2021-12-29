import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/bill.dart';

class AccountListTemplate extends StatefulWidget {
  const AccountListTemplate( {Key? key, required this.account }) : super(key: key);

  final ToOne<Account>  account;

  @override
  State<StatefulWidget> createState() {
    return _AccountListTemplate(account);
  }
}

class _AccountListTemplate extends State<AccountListTemplate> {
  late Store _store;
  late Stream<List<Bill>> _billsStream;
  final ToOne<Account>  account;

  _AccountListTemplate(this.account);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: StreamBuilder<List<Bill>>(
          stream: _billsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DataTable(
                columns: const [
                  DataColumn(
                    label: Text('Cena'),
                  ),
                  DataColumn(
                    label: Text('Zapłacone'),
                  ),
                  DataColumn(
                    label: Text('Zajęcia'),
                  ),
                  DataColumn(
                    label: Text('Adres'),
                  ),
                ],
                rows: snapshot.data!.map(
                  (bill) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(bill.price.toString()),
                        ),
                        DataCell(
                          Text(bill.isPaid.toString()),
                        ),
                        DataCell(
                          Text(bill.classes.target!.group!.target!.name),
                        ),
                        DataCell(
                          Text(bill.classes!.target!.group!.target!.address!
                              .target!.street),
                        ),
                      ],
                    );
                  },
                ).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _billsStream = _store
        .box<Bill>()
        .query( )
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
