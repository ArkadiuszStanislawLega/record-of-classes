import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';

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
            _store = objectBox.store;
            _store.box<ClassesType>().remove(classesType.id);
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
                    '${classesType.priceForMonth.toString()}${Strings.CURRENCY}')
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
        onTap: () {
          Navigator.pushNamed(context, AppUrls.DETAIL_CLASSES_TYPE,
              arguments: classesType);
        },
      ),
    );
  }

  void _showInfo(var context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Typ zajęć: ${classesType.name} - usunięty!'),
        duration: const Duration(milliseconds: 1500),
        width: 280.0,
        // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
