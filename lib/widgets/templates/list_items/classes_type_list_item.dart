import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class ClassesTypeListItem extends StatelessWidget {
  ClassesTypeListItem({Key? key, required this.classesType}) : super(key: key);
  final ClassesType classesType;
  late Store _store;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: Strings.DELETE,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _updateDatabase();
            _showInfo(context);
          },
        ),
      ],
      child: ListTile(
        title: Text(classesType.name),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text('${Strings.PRICE_FOR_MONTH}:'),
                Text(
                    '${classesType.priceForMonth.toString()}${Strings
                        .CURRENCY}')
              ],
            ),
            Column(
              children: [
                const Text('${Strings.PRICE_FOR_EACH}:'),
                Text(
                    '${classesType.priceForEach.toString()}${Strings.CURRENCY}')
              ],
            ),
          ],
        ),
        onTap: () => _navigateToDetailClassesProfile(context)
      ),
    );
  }

  void _updateDatabase(){
    _store = objectBox.store;
    _store.box<ClassesType>().remove(classesType.id);
  }

  void _navigateToDetailClassesProfile(BuildContext context) => Navigator.pushNamed(context, AppUrls.DETAIL_CLASSES_TYPE,
      arguments: classesType);


  void _showInfo(BuildContext context) =>
      SnackBarInfoTemplate(context: context,
          message: '${Strings.CLASSES_TYPE}: ${classesType.name} - ${Strings
              .REMOVED}!');
}