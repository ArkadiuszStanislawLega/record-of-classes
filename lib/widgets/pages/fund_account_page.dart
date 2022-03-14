import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:record_of_classes/widgets/templates/text_field_template.dart';
import 'package:record_of_classes/widgets/templates/text_field_template_double.dart';

class FundAccountPage extends StatefulWidget {
  const FundAccountPage({Key? key}) : super(key: key);

  @override
  _FundAccountPageState createState() => _FundAccountPageState();
}

class _FundAccountPageState extends State<FundAccountPage> {
  late Student _student;
  late Function? _fundAccountUpdateDb;
  late Map args;
  late TextFieldTemplateDouble _inputAmount;
  static const double _sizedBoxHeight = 20.0;
  static const double _smallPaddings = 5.0;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map;
    _student = args[AppStrings.student];
    _fundAccountUpdateDb = args[AppStrings.function];
    _inputAmount =
        TextFieldTemplateDouble(label: AppStrings.enterAmount, hint: '');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.fundAccount,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              '${AppStrings.studentAccount}:',
              style: Theme.of(context).textTheme.headline2,
            ),
            Container(
              margin: const EdgeInsets.all(_smallPaddings),
              child: Text(
                _student.introduceYourself(),
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            const SizedBox(
              height: _sizedBoxHeight,
            ),
            Text(
              '${AppStrings.currentStateOfBalance}: ',
              style: Theme.of(context).textTheme.headline2,
            ),
            Container(
              margin: const EdgeInsets.all(_smallPaddings),
              child: Text(
                '${_student.account.target!.balance.toStringAsFixed(2)}${AppStrings.currency}',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            const SizedBox(
              height: _sizedBoxHeight,
            ),
            _inputAmount,
            const SizedBox(
              height: _sizedBoxHeight,
            ),
            TextButton(
              onPressed: _updateDatabase,
              child: const Text(AppStrings.fund),
            )
          ],
        ),
      ),
    );
  }

  void _updateDatabase() {
    _fundAccountUpdateDb!(value: double.parse(_inputAmount.input));

    SnackBarInfoTemplate(
        context: context,
        message:
            '${AppStrings.fundedAccount} ${_student.introduceYourself()} ${AppStrings.amount} ${_inputAmount.input}${AppStrings.currency}');
    Navigator.pop(context);
  }
}
