import 'package:record_of_classes/constants/app_strings.dart';

enum ActionType{
  none,
  add,
  remove,
  update,
  create,
  increase,
  decrease
}

 final Map convertActionTypeToString = {
  ActionType.none.index: AppStrings.lack,
  ActionType.add.index: AppStrings.added,
  ActionType.remove.index: AppStrings.removed,
  ActionType.update.index: AppStrings.updated,
  ActionType.create.index: AppStrings.created,
  ActionType.increase.index: AppStrings.enlarged,
  ActionType.decrease.index: AppStrings.reduced,
};