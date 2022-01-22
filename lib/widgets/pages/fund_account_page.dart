import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class FundAccountPage extends StatefulWidget {
  const FundAccountPage({Key? key}) : super(key: key);

  @override
  _FundAccountPageState createState() => _FundAccountPageState();
}

class _FundAccountPageState extends State<FundAccountPage> {
  late Student _student;
  double _inputedAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    _student= ModalRoute.of(context)!.settings.arguments as Student;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.FUND_ACCOUNT),
      ),
      body: Column(
        children: [
          Text('${Strings.STUDENT_ACCOUNT} ${_student.introduceYourself()}'),
          Text('${Strings.CURRENT_STATE_OF_BALANCE}: ${_student.account.target!.balance.toStringAsFixed(2)}${Strings.CURRENCY}'),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.ENTER_AMOUNT,
            ),
            onChanged: (userInput) => _inputedAmount = double.parse(userInput),
          ),
          TextButton(
            onPressed: _updateDatabase,
            child: const Text(Strings.FUND),
          )
        ],
      ),
    );
  }
  void _updateDatabase(){
    setState(() {
      _student.account.target!.balance += _inputedAmount;
      objectBox.store.box<Account>().put(_student.account.target!);
    });

    SnackBarInfoTemplate(context: context, message: '${Strings.FUNDED_ACCOUNT} ${_student.introduceYourself()} ${Strings.AMOUNT} $_inputedAmount${Strings.CURRENCY}');
    Navigator.pop(context);
  }
}
