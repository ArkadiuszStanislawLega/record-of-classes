import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/enumerators/ActionType.dart';
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

  final Map _colorsDependsOnActionType = {
    ActionType.none.index: Colors.white,
    ActionType.add.index: Colors.green,
    ActionType.remove.index: Colors.red,
    ActionType.update.index: Colors.blue,
    ActionType.create.index: Colors.lightGreenAccent,
    ActionType.increase.index: Colors.black38,
    ActionType.decrease.index: Colors.orange,
  };

  @override
  Widget build(BuildContext context) {
    _enumToModel();
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
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blue,
                  child: Text(
                    widget.log.id.toString(),
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(20)),
                      color: Colors.black26),
                  child: Text(
                    '${formatDate(widget.log.date)} ${formatTime(widget.log.date)}',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(top: 30.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 9.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20)),
                      color: _colorsDependsOnActionType[widget.log.actionType]),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: RichText(
                      text: TextSpan(
                        text: _actionTypeToString(),
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  ),
                ),
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

  Widget _showAccount() {
    return widget.log.eActionType == ActionType.add
        ? Column(
            children: [
              Text(
                  '${AppStrings.accountWasCreatedFor}: ${_account.student.target!.person.target!.introduceYourself()}')
            ],
          )
        : Column(
            children: [
              Text(_account.student.target!.introduceYourself()),
              Text(
                  '${AppStrings.accountBalanceBeforeChange}: ${widget.log.valueBeforeChange}${AppStrings.currency}'),
              Text(
                  '${AppStrings.changeValue}: ${widget.log.value}${AppStrings.currency}'),
              (double.tryParse(widget.log.valueBeforeChange) != null &&
                      double.tryParse(widget.log.value) != null)
                  ? Text(
                      '${AppStrings.accountBalanceBeforeChange}: ${(double.parse(widget.log.valueBeforeChange) + double.parse(widget.log.value)).toStringAsFixed(2)}${AppStrings.currency}')
                  : SizedBox()
            ],
          );
  }

  Widget _showBill() {
    return Column(
      children: [Text(_bill.toString())],
    );
  }

  void _enumToModel() {
    if (widget.log.modelType == 1) {
      _account =
          ObjectBox.store.box<Account>().get(widget.log.participatingClassId)!;
    } else if (widget.log.modelType == 2) {
      _bill = ObjectBox.store.box<Bill>().get(widget.log.participatingClassId)!;
    }
  }

  String _actionTypeToString() {
    Map strings = {
      ActionType.none.index: AppStrings.lack,
      ActionType.add.index: AppStrings.added,
      ActionType.remove.index: AppStrings.removed,
      ActionType.update.index: AppStrings.updated,
      ActionType.create.index: AppStrings.created,
      ActionType.increase.index: AppStrings.enlarged,
      ActionType.decrease.index: AppStrings.reduced,
    };
    if (strings.containsKey(widget.log.actionType)) {
      return strings[widget.log.actionType];
    }
    return strings[ActionType.none];
  }
}
