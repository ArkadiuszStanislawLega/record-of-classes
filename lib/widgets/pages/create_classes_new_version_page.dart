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
import 'package:record_of_classes/models/student.dart';

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
  List<Student> _studentsList = [];

  @override
  Widget build(BuildContext context) {
    _studentsList = objectBox.store.box<Student>().getAll();
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.CREATED_NEW_CLASSES),
      ),
      body: StreamBuilder<List<ClassesType>>(
        stream: _classesType,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _prepareData(snapshot.data!);
            _controller.treeData(_elements);
            return _treeView();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _prepareData(List<ClassesType> data) {
    for (var classesType in data) {
      TreeNodeData classesTypeNode =
          TreeNodeData(label: classesType.name, object: classesType);
      _prepareGroupNode(classesTypeNode);
      _elements.add(classesTypeNode);
    }
  }

  void _prepareGroupNode(TreeNodeData parent) {
    if (parent.object is ClassesType) {
      for (var group in parent.object!.groups) {
        TreeNodeData groupNode = TreeNodeData(label: group.name, object: group);
        _prepareClassesNode(groupNode);
        parent.addChild(groupNode);
      }
    }
  }

  void _prepareClassesNode(TreeNodeData parent) {
    if (parent.object is Group) {
      var group = parent.object as Group;
      group.classes
          .sort((item, item2) => item.dateTime.compareTo(item2.dateTime));
      for (var classes in group.classes.reversed) {
        parent.addChild(
            TreeNodeData(label: formatDate(classes.dateTime), object: classes));
      }
    }
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
                        children: [_getItem(item)],
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
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          add(item);
                          //TODO: Baza daynch
                        },
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          delete(item);
                          //TODO: Baza daynch
                        },
                        child: const Icon(
                          Icons.remove,
                          size: 30,
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        );
      },
      onTap: (NodeData data) {
        var treeNodeData = data as TreeNodeData;
        if (treeNodeData.object != null) {
          _getItem(treeNodeData);
        } else {
          Text(treeNodeData.label);
        }
        // print('index = ${data.index}');
      },
      onLongPress: (data) {
        delete(data);
      },
      controller: _controller,
    );
  }

  Widget _classesTypeItem(ClassesType classesType) {
    return Container(color: Colors.blueGrey, child: Text(classesType.name));
  }

  Widget _classesItem(Classes classes) {
    return SizedBox(
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
            title: Text(classes.group.target!.name),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatDate(classes.dateTime)),
                Text(formatTime(classes.dateTime))
              ],
            ),
            onTap: () {
              // _navigateToGroupProfile(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _groupItem(Group group) {
    return Slidable(
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
          color: Colors.orangeAccent,
          child: Text(group.name),
        ));
  }

  Widget _getItem(TreeNodeData data) {
    if (data.object != null) {
      if (data.object is Classes) {
        return _classesItem(data.object);
      }
      if (data.object is Group) {
        return _groupItem(data.object);
      }
      if (data.object is ClassesType) {
        return _classesTypeItem(data.object);
      }
    }
    return Text(data.label);
  }

  void add(TreeNodeData dataNode) {
    var newNode = TreeNodeData(
      label: dataNode.label,
    );

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
  TreeNodeData({required this.label, this.object}) : super();
  final String label;
  late var object;
}
