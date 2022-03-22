import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_colours.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/enumerators/ActionType.dart';
import 'package:record_of_classes/enumerators/ModelType.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/models/log.dart';

class LogListItemTemplate extends StatefulWidget {
  const LogListItemTemplate({Key? key, required this.log}) : super(key: key);
  final Log log;

  @override
  State<LogListItemTemplate> createState() => _LogListItemTemplateState();
}

class _LogListItemTemplateState extends State<LogListItemTemplate> {
  Account _account = Account();
  Bill _bill = Bill();

  @override
  Widget build(BuildContext context) {
    _downloadModelDependsOnType();
    return Container(
      margin: const EdgeInsets.only(bottom: 2.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20.0)),
          color: Colors.white38),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _showIdNumber(),
                _showDate(),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(top: 30.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _showTypeOfLog(),
                Column(
                  children: [
                    _account.id > 0 ? _showAccount() : _showBill(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showIdNumber() => Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.blue,
        child: Text(
          widget.log.id.toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
      );

  Widget _showDate() => Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
            color: Colors.black26),
        child: Text(
          '${formatDate(widget.log.date)} ${formatTime(widget.log.date)}',
          style: Theme.of(context).textTheme.headline2,
        ),
      );

  Widget _showTypeOfLog() => Container(
        margin: const EdgeInsets.only(top: 9.0),
        padding: EdgeInsets.all(widget.log.id > 9 ? 9.0 : 5.0),
        decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.only(bottomRight: Radius.circular(20)),
            color: AppColors.colorsDependsOnActionType[widget.log.actionType]),
        child: RotatedBox(
          quarterTurns: 1,
          child: RichText(
            text: TextSpan(
              text: _convertActionTypeToString(),
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        ),
      );

  Widget _showAccount() {
    final Map _accountWidgetDependsOnType = {
      ActionType.add: _showCreatedAccount(),
      ActionType.update: _showUpdateAccount(),
      ActionType.increase: _showUpdateAccount(),
      ActionType.decrease: _showUpdateAccount(),
    };
    if (_accountWidgetDependsOnType.containsKey(widget.log.eActionType)) {
      return _accountWidgetDependsOnType[widget.log.eActionType];
    }
    return _showUpdateAccount();
  }

  Widget _showCreatedAccount() => Column(
        children: [
          Text(
              '${AppStrings.accountWasCreatedFor}: ${_account.student.target!.person.target!.introduceYourself()}')
        ],
      );

  Widget _showUpdateAccount() => Column(
        children: [
          Text(
            _account.student.target == null
                ? AppStrings.deletedStudent
                : _account.student.target!.introduceYourself(),
          ),
          Text(
            '${AppStrings.accountBalanceBeforeChange}: ${widget.log.valueBeforeChange}${AppStrings.currency}',
          ),
          Text(
            '${AppStrings.changeValue}: ${widget.log.value}${AppStrings.currency}',
          ),
          (double.tryParse(widget.log.valueBeforeChange) != null &&
                  double.tryParse(widget.log.value) != null)
              ? Text(
                  '${AppStrings.accountBalanceAfterChange}: ${(double.parse(widget.log.valueBeforeChange) + double.parse(widget.log.value)).toStringAsFixed(2)}${AppStrings.currency}',
                )
              : const SizedBox()
        ],
      );

  Widget _showBill() {
    return Column(
      children: [Text(_bill.toString())],
    );
  }

  void _downloadModelDependsOnType() {
    if (widget.log.modelType == ModelType.account.index) {
      _account =
          ObjectBox.store.box<Account>().get(widget.log.participatingClassId)!;
    } else if (widget.log.modelType == ModelType.bill.index) {
      _bill = ObjectBox.store.box<Bill>().get(widget.log.participatingClassId)!;
    }
  }

  String _convertActionTypeToString() {
    if (convertActionTypeToString.containsKey(widget.log.actionType)) {
      return convertActionTypeToString[widget.log.actionType];
    }
    return convertActionTypeToString[ActionType.none];
  }
}
