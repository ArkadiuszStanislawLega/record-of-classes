import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/person.dart';

class ParentListItemTemplate extends StatefulWidget {
  ParentListItemTemplate({Key? key, required this.parent}) : super(key: key);
  Parent parent;

  @override
  State<StatefulWidget> createState() {
    return _ParentListItemTemplate();
  }
}

class _ParentListItemTemplate extends State<ParentListItemTemplate> {
  late Store _store;
  @override
  Widget build(BuildContext context) {
    _store = objectBox.store;
    if (widget.parent.person.target != null) {
      return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
              caption: Strings.DELETE,
              color: Colors.red,
              icon: Icons.delete,
              onTap: removeParent),
        ],
        child: ListTile(
            title: Column(children: personData()), onTap: enterParentProfile),
      );
    }
    return const Text('');
  }

  void enterParentProfile() {
    Navigator.pushNamed(context, AppUrls.DETAIL_PARENT,
        arguments: widget.parent);
  }

  void removeParent() {
    _store.box<Parent>().remove(widget.parent.id);
    _store.box<Person>().remove(widget.parent.person.target!.id);
  }

  List<Widget> personData() {
    var person = widget.parent.person.target!;
    return [
      Text('${person.surname} ${person.name} ',
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.bold),
      ),
    ];
  }

}
