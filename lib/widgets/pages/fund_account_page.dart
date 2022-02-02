import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class FundAccountPage extends StatefulWidget {
  const FundAccountPage({Key? key}) : super(key: key);

  @override
  _FundAccountPageState createState() => _FundAccountPageState();
}

class _FundAccountPageState extends State<FundAccountPage> {
  late Student _student;
  late Function? _fundAccountUpdateDb;
  late Map args;
  double _input = 0.0;

  @override
  Widget build(BuildContext context) {
   args = ModalRoute.of(context)!.settings.arguments as Map;
   _student = args[AppStrings.STUDENT];
   _fundAccountUpdateDb = args[AppStrings.FUNCTION];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.FUND_ACCOUNT),
      ),
      body: Column(
        children: [
          Text('${AppStrings.STUDENT_ACCOUNT} ${_student.introduceYourself()}'),
          Text('${AppStrings.CURRENT_STATE_OF_BALANCE}: ${_student.account.target!.balance.toStringAsFixed(2)}${AppStrings.CURRENCY}'),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: AppStrings.ENTER_AMOUNT,
            ),
            onChanged: (userInput) => _input= double.parse(userInput),
          ),
          TextButton(
            onPressed: _updateDatabase,
            child: const Text(AppStrings.FUND),
          )
        ],
      ),
    );
  }
  void _updateDatabase(){
    _fundAccountUpdateDb!(value: _input);

    SnackBarInfoTemplate(context: context, message: '${AppStrings.FUNDED_ACCOUNT} ${_student.introduceYourself()} ${AppStrings.AMOUNT} $_input${AppStrings.CURRENCY}');
    Navigator.pop(context);
  }
}
