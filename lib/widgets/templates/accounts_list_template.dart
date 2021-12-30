import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/address.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/group.dart';

class AccountListTemplate extends StatefulWidget {
  const AccountListTemplate( {Key? key, required this.account }) : super(key: key);

  final ToOne<Account>  account;

  @override
  State<StatefulWidget> createState() {
    return _AccountListTemplate();
  }
}

class _AccountListTemplate extends State<AccountListTemplate> {
  late Store _store;
  late Stream<List<Bill>> _billsStream;
  late ToOne<Account>  account;
  late ToOne<Group> group;


  @override
  Widget build(BuildContext context) {
    account = widget.account;

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
                    Classes classes = bill.classes.target as Classes;
                    Group group = classes.group.target as Group;
                    Address address = group.address.target as Address;

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(bill.price.toString()),
                        ),
                        DataCell(
                          Text(bill.isPaid.toString()),
                        ),
                        DataCell(
                          Text(group.name),
                        ),
                        DataCell(
                          Text(address.street),
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
