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
    ActionType.increase.index: Colors.yellowAccent,
    ActionType.decrease.index: Colors.orange,
  };

  @override
  Widget build(BuildContext context) {
    _enumToModel();
    return Container(
      margin: const EdgeInsets.all(2.0),
      padding: const EdgeInsets.all(10.0),
      color: Colors.white38,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.log.id.toString()),
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: _colorsDependsOnActionType[widget.log.actionType]),
                child: Text(_actionTypeToString()),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white38),
                child: Text(
                    '${formatDate(widget.log.date)} ${formatTime(widget.log.date)}'),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _account.id > 0 ? _showAccount() : _showBill(),
                widget.log.value == ''
                    ? const SizedBox()
                    : Text('Wartość: ${widget.log.value}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showAccount() {
    return Column(
      children: [
        Text(_account.student.target!.introduceYourself()),
        Text('Aktualny stan konta: ${_account.balance.toString()}${AppStrings.currency}')
      ],
    );
  }

  Widget _showBill() {
    return Column(
      children: [
        Text(_bill.toString())
      ],
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
      ActionType.none.index: 'Brak',
      ActionType.add.index: 'Dodaj',
      ActionType.remove.index: 'Usuń',
      ActionType.update.index: 'Aktualizuj',
      ActionType.create.index: 'Utwórz',
      ActionType.increase.index: 'Powiększ',
      ActionType.decrease.index: 'Zmniejsz',
    };
    if (strings.containsKey(widget.log.actionType)) {
      return strings[widget.log.actionType];
    }
    return strings[ActionType.none];
  }
}
