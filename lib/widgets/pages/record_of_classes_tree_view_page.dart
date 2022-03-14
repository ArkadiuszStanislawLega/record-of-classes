import 'package:flutter/material.dart';
import 'package:list_treeview/tree/controller/tree_controller.dart';
import 'package:list_treeview/tree/node/tree_node.dart';
import 'package:list_treeview/tree/tree_view.dart';
import 'package:record_of_classes/constants/app_colours.dart';
import 'package:record_of_classes/constants/app_doubles.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/classes_tree_view_item.dart';
import 'package:record_of_classes/widgets/templates/classes_tree_view_item_expanded.dart';
import 'package:record_of_classes/widgets/templates/classes_type_treeview_item.dart';
import 'package:record_of_classes/widgets/templates/group_tree_view_item.dart';
import 'package:record_of_classes/widgets/templates/group_tree_view_item_expanded.dart';
import 'package:record_of_classes/widgets/templates/icon_in_card_template.dart';
import 'package:record_of_classes/widgets/templates/classes_type_tree_view_item_expanded.dart';

class RecordOfClassesTreeViewPage extends StatefulWidget {
  RecordOfClassesTreeViewPage({Key? key}) : super(key: key);

  @override
  _RecordOfClassesTreeViewPageState createState() =>
      _RecordOfClassesTreeViewPageState();
}

class _RecordOfClassesTreeViewPageState
    extends State<RecordOfClassesTreeViewPage> {
  late TreeViewController _controller;
  late Stream<List<ClassesType>> _classesTypeStream;
  late TreeNodeData _selectedTreeNodeData;

  List<TreeNodeData> _elements = [];

  final double _itemsOffset = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.management,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: StreamBuilder<List<ClassesType>>(
        stream: _classesTypeStream,
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
      itemBuilder: (BuildContext context, NodeData data) {
        TreeNodeData item = data as TreeNodeData;
        double offsetX = item.level * _itemsOffset;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDoubles.paddings),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: AppDoubles.borderWidth, color: AppColors.borderColor),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: offsetX),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [_getItem(item, isExpanded: item.isExpand)],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(visible: item.isExpand, child: _buttonsColumn(item))
            ],
          ),
        );
      },
      onTap: (NodeData data) {
        var treeNodeData = data as TreeNodeData;
        _getItem(treeNodeData, isExpanded: data.isExpand);
      },
      onLongPress: (data) {
        var node = data as TreeNodeData;
        delete(data);
      },
      controller: _controller,
    );
  }

  Widget _buttonsColumn(TreeNodeData item) {
    return Column(
      children: [
        _removeItemButton(item),
        _addItemButton(item),
      ],
    );
  }

  Widget _addItemButton(TreeNodeData item) {
    bool isObjectInstanceOfClasses = item.object is Classes;
    return !isObjectInstanceOfClasses
        ? InkWell(
            onTap: () => add(item),
            child: IconInCardTemplate(
                icon: Icons.add, background: AppColors.addButtonBackground),
          )
        : const SizedBox();
  }

  Widget _removeItemButton(TreeNodeData item) {
    return InkWell(
        onTap: () {
          _removeDialogWindow(item);
        },
        child: IconInCardTemplate(
            icon: Icons.delete, background: AppColors.removeButtonBackground));
  }

  void _removeDialogWindow(TreeNodeData item) {
    Widget content = Text('');

    if (item.object is Classes) {
      var classes = item.object as Classes;
      content = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('${AppStrings.areYouSureToRemove} ${AppStrings.classes}:'),
              Text(
                classes.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('${AppStrings.onDate}:'),
                Text(
                  formatDate(classes.dateTime),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('${AppStrings.atTime}:'),
                  Text(
                    formatTime(classes.dateTime),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
          const Text(
            AppStrings.dialogWarningMessageRemoveClasses,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      );
    }
    if (item.object is Group) {
      var group = item.object as Group;
      content = Text('${AppStrings.areYouSureToRemove}  ${group.name}');
    }
    if (item.object is ClassesType) {
      var classesType = item.object as ClassesType;
      content =
          Text('${AppStrings.areYouSureToRemove} ${classesType.name}');
    }

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(AppStrings.confirmRemoving),
          content: content,
          actions: [
            // The "Yes" button
            TextButton(
                onPressed: () {
                  _removeClassesFromDb(item);
                  _removeGroupFromDb(item);
                  _removeClassesTypeFromDb(item);
                  Navigator.of(context).pop();
                  delete(item);
                },
                child: const Text(AppStrings.yes)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(AppStrings.no))
          ],
        );
      },
    );
  }

  void _removeClassesFromDb(TreeNodeData item) {
    if (item.object is Classes) {
      setState(() {
        item.object.group.target!.removeClasses(item.object.id);
      });
    }
  }

  void _removeGroupFromDb(TreeNodeData item) {
    if (item.object is Group) {
      setState(() {
        item.object.classesType.target!.removeGroup(item.object.id);
      });
    }
  }

  void _removeClassesTypeFromDb(TreeNodeData item) {
    if (item.object is ClassesType) {
      setState(() {
        item.object.removeFromDb();
      });
    }
  }

  Widget _getItem(TreeNodeData data, {bool isExpanded = false}) {
    if (data.object != null) {
      if (data.object is Classes) {
        return isExpanded
            ? ClassesTreeViewItemExpanded(classes: data.object)
            : ClassesTreeViewItem(classes: data.object);
      }
      if (data.object is Group) {
        return isExpanded
            ? GroupTreeViewItemExpanded(group: data.object)
            : GroupTreeViewItem(group: data.object);
      }
      if (data.object is ClassesType) {
        return isExpanded
            ? ClassesTypeTreeViewItemExpanded(classesType: data.object)
            : ClassesTypeTreeViewItem(classesType: data.object);
      }
    }
    return Text(data.label);
  }

  void add(TreeNodeData dataNode) {
    _selectedTreeNodeData = dataNode;
    if (dataNode.object is Group) {
      Navigator.pushNamed(
        context,
        AppUrls.addClassesToGroup,
        arguments: {
          AppStrings.group: dataNode.object,
          AppStrings.function: _addClasses
        },
      );
    }

    if (dataNode.object is ClassesType) {
      Navigator.pushNamed(
        context,
        AppUrls.createGroup,
        arguments: {
          AppStrings.classesType: dataNode.object,
          AppStrings.function: _addGroup
        },
      );
    }

    // _controller.insertAtFront(dataNode, newNode);
//    _controller.insertAtRear(dataNode, newNode);
//    _controller.insertAtIndex(1, dataNode, newNode);
  }

  void _addClasses(Classes classes) {
    setState(() {
      classes.group.target!.addClasses(classes);
      var newNode = TreeNodeData(label: classes.name, object: classes);
      _controller.insertAtFront(_selectedTreeNodeData, newNode);
    });
  }

  void _addGroup(Group group) {
    setState(() {
      group.classesType.target!.addGroup(group);
      var newNode = TreeNodeData(label: group.name, object: group);
      _controller.insertAtFront(_selectedTreeNodeData, newNode);
    });
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
    _classesTypeStream = ObjectBox.store
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
