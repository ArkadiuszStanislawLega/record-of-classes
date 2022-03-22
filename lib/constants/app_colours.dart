import 'package:flutter/material.dart';
import 'package:record_of_classes/enumerators/ActionType.dart';

class AppColors{
  static final Map colorsDependsOnActionType = {
    ActionType.none.index: Colors.white,
    ActionType.add.index: Colors.green,
    ActionType.remove.index: Colors.red,
    ActionType.update.index: Colors.blue,
    ActionType.create.index: Colors.lightGreenAccent,
    ActionType.increase.index: Colors.black38,
    ActionType.decrease.index: Colors.orange,
  };

  static final Color classesTypeBackground = Colors.brown.shade700,
      groupBackground = Colors.brown.shade300,
      borderColor = Colors.white60,
      addButtonBackground = Colors.green.shade500,
      removeButtonBackground = Colors.red,
      iconForegroundColor = Colors.white,
      navigateArrowBackground = Colors.orange,
      navigateButtonForeground = Colors.white;

  static final Map colorsOfTheMonth = {
    1: Colors.red.shade200,
    2: Colors.blue.shade200,
    3: Colors.green.shade200,
    4: Colors.yellow.shade200,
    5: Colors.orange.shade200,
    6: Colors.indigo.shade200,
    7: Colors.blueGrey.shade200,
    8: Colors.cyan.shade200,
    9: Colors.lightGreen.shade200,
    10: Colors.amber.shade200,
    11: Colors.deepPurple.shade200,
    12: Colors.teal.shade200
  };
}