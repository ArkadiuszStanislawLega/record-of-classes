import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/parent_list_item_template.dart';

class ParentListTemplate extends StatefulWidget{
  Student? children;

  ParentListTemplate({Key? key, this.children}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ParentListTemplate();
  }

}

class _ParentListTemplate extends State<ParentListTemplate>{
  late Store _store;
  late Stream<List<Parent>> _parentsStream;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.all(5),
      child: StreamBuilder<List<Parent>>(
        stream: _parentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(itemCount: snapshot.data!.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ParentListItemTemplate(parent: snapshot.data!.elementAt(index));
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },

      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _parentsStream = _store
        .box<Parent>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}