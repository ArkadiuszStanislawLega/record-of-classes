import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/widgets/templates/lists/all_unpaid_bills_list_template.dart';

class FinanceMainPage extends StatefulWidget {
  const FinanceMainPage({Key? key}) : super(key: key);

  @override
  _FinanceMainPageState createState() => _FinanceMainPageState();
}

class _FinanceMainPageState extends State<FinanceMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.FINANCE),
      ),
      body: Column(
        children: const [AllUnpaidBillsTemplate()],
      ),
    );
  }
}
