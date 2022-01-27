import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:list_treeview/tree/controller/tree_controller.dart';
import 'package:list_treeview/tree/node/tree_node.dart';
import 'package:list_treeview/tree/tree_view.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/pages/add/add_classes_to_group_template.dart';
import 'package:record_of_classes/widgets/pages/add/add_student_to_group_page.dart';
import 'package:record_of_classes/widgets/templates/add_new_classes_type_template.dart';
import 'package:record_of_classes/widgets/templates/create/create_group_template.dart';
import 'package:record_of_classes/widgets/templates/list_items/classes_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/list_items/classes_type_list_item.dart';

class CreateClassesNewVersionPage extends StatefulWidget {
  const CreateClassesNewVersionPage({Key? key}) : super(key: key);

  @override
  _CreateClassesNewVersionPageState createState() =>
      _CreateClassesNewVersionPageState();
}

class _CreateClassesNewVersionPageState
    extends State<CreateClassesNewVersionPage> {
  late TreeViewController _controller;
  DateTime selectedDate = DateTime.now(), selectedTime = DateTime.now();
  late Stream<List<ClassesType>> _classesType;
  List<TreeNodeData> _elements = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.CREATED_NEW_CLASSES),
      ),
      body: StreamBuilder<List<ClassesType>>(
        stream: _classesType,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (var classesType in snapshot.data!) {
              TreeNodeData classesTypeNode =
                  TreeNodeData(property1: classesType.name);
              for (var group in classesType.groups) {
                TreeNodeData groupNode = TreeNodeData(property1: group.name);
                classesTypeNode.addChild(groupNode);
                for (var classes in group.classes) {
                  groupNode.addChild(TreeNodeData(
                      property1: formatDate(classes.dateTime),
                      classes: classes));
                }
              }
              _elements.add(classesTypeNode);
            }
            _controller.treeData(_elements);
            return _treeView();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _treeView() {
    return ListTreeView(
      shrinkWrap: false,
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, NodeData data) {
        TreeNodeData item = data as TreeNodeData;
//              double width = MediaQuery.of(context).size.width;
        double offsetX = item.level * 16.0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: offsetX, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          item.classes != null
                              ? Container(
                                  width: 270,
                                  child: Slidable(
                                    actionPane: const SlidableDrawerActionPane(),
                                    secondaryActions: [
                                      IconSlideAction(
                                        caption: Strings.DELETE,
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () {
                                          // removeFromDbFunction!(classes);
                                          // _showInfo(context);
                                        },
                                      ),
                                    ],
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(color: Colors.white70, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                                      elevation: 7,
                                      child: ListTile(
                                        title: Text(item.classes!.group.target!.name),
                                        subtitle: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(formatDate(item.classes!.dateTime)),
                                            Text(formatTime(item.classes!.dateTime))
                                          ],
                                        ),
                                        onTap: () {
                                          // _navigateToGroupProfile(context);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Text(item.property1),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: item.isExpand,
                child: InkWell(
                  onTap: () {
                    add(item);
                  },
                  child: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        );
      },
      onTap: (NodeData data) {
        var treeNodeData = data as TreeNodeData;
        ClassesListItemTemplate(classes: treeNodeData.classes!);
        print('index = ${data.index}');
      },
      onLongPress: (data) {
        delete(data);
      },
      controller: _controller,
    );
  }

  void add(TreeNodeData dataNode) {
    int r = 100;
    int g = 200;
    int b = 10;

    var newNode = TreeNodeData(
        label: 'rgb($r,$g,$b)',
        color: Color.fromARGB(255, r, g, b),
        property1: '');

    _controller.insertAtFront(dataNode, newNode);
//    _controller.insertAtRear(dataNode, newNode);
//    _controller.insertAtIndex(1, dataNode, newNode);
  }

  void delete(dynamic item) {
    _controller.removeItem(item);
  }

  void select(dynamic item) {
    _controller.selectItem(item);
  }

  void selectAllChild(dynamic item) {
    _controller.selectAllChild(item);
  }

  @override
  void initState() {
    super.initState();
    _controller = TreeViewController();
    _classesType = objectBox.store
        .box<ClassesType>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}

class TreeNodeData extends NodeData {
  TreeNodeData(
      {this.label,
      this.color = Colors.black,
      required this.property1,
      this.classes})
      : super();
  final String? label;
  final Color? color;
  late String property1;
  late String property2;
  late String property3;
  late Classes? classes;
}
