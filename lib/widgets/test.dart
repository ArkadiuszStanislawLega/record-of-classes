import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  late Store _store;
  late Stream<List<Account>> _accountsSteam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('text'),
      ),
      body: StreamBuilder<List<Account>>(
        stream: _accountsSteam,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Account account = snapshot.data!.elementAt(index);
                return Text(
                    '${account.id.toString()} ${account.student.target!.person.target!.introduceYourself()}');
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _store = ObjectBox.store;
    _accountsSteam = _store
        .box<Account>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
