import 'package:flutter/material.dart';
import 'package:list_treeview/tree/controller/tree_controller.dart';
import 'package:list_treeview/tree/node/tree_node.dart';
import 'package:list_treeview/tree/tree_view.dart';
import 'package:record_of_classes/constants/app_colours.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/classes_type_item_template.dart';
import 'package:record_of_classes/widgets/templates/classes_type_treeview_item.dart';
import 'package:record_of_classes/widgets/templates/group_item_template.dart';
import 'package:record_of_classes/widgets/templates/icon_in_card_template.dart';
import 'package:record_of_classes/widgets/templates/item_content_template.dart';
import 'package:record_of_classes/widgets/templates/item_title_template.dart';
import 'package:record_of_classes/widgets/templates/classes_type_tree_view_item_expanded.dart';
import 'package:record_of_classes/widgets/templates/lists/property_in_one_row.dart';

class CreateClassesNewVersionPage extends StatefulWidget {
  const CreateClassesNewVersionPage({Key? key}) : super(key: key);

  @override
  _CreateClassesNewVersionPageState createState() =>
      _CreateClassesNewVersionPageState();
}

class _CreateClassesNewVersionPageState
    extends State<CreateClassesNewVersionPage> {
  late TreeViewController _controller;
  late Stream<List<ClassesType>> _classesType;

  List<TreeNodeData> _elements = [];
  List<Student> _studentsList = [];

  DateTime selectedDate = DateTime.now(), selectedTime = DateTime.now();

  final Map _colorsOfTheMonth = {
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

  final Color _classesTypeBackground = Colors.blueGrey.shade400,
      _groupBackground = Colors.blueGrey.shade200,
      _borderColor = Colors.grey,
      _addButtonBackground = Colors.green.shade500,
      _removeButtonBackground = Colors.red,
      _iconForegroundColor = Colors.white,
      _navigateArrowBackground = Colors.orange,
      _navigateButtonForeground = Colors.white;

  final double _itemsOffset = 15.0,
      _borderWidth = 1.0,
      _classesTypeWidth = 80.0,
      _groupWidth = 95.0,
      _classesWidth = 100.0,
      _margins = 10.0,
      _paddings = 5.0,
      _cornerEdges = 10.0,
      _titleFontSize = 16,
      _classesTypeElevation = 9.0,
      _groupElevation = 6.0,
      _classesElevation = 3.0,
      _iconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    _studentsList = objectBox.store.box<Student>().getAll();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.CREATED_NEW_CLASSES),
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
      itemBuilder: (BuildContext context, NodeData data) {
        TreeNodeData item = data as TreeNodeData;
        double offsetX = item.level * _itemsOffset;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: _paddings),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: _borderWidth, color: _borderColor),
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
              Visibility(
                  visible: item.isExpand, child: _addAndRemoveButtons(item))
            ],
          ),
        );
      },
      onTap: (NodeData data) {
        var treeNodeData = data as TreeNodeData;
        _getItem(treeNodeData, isExpanded: data.isExpand);
      },
      onLongPress: (data) {
        delete(data);
      },
      controller: _controller,
    );
  }

  Widget _addAndRemoveButtons(TreeNodeData item) {
    return Column(
      children: [
        _removeButton(item),
        _addButton(item),
      ],
    );
  }

  Widget _addButton(TreeNodeData item) {
    bool isObjectInstanceOfClasses = item.object is Classes;
    return !isObjectInstanceOfClasses
        ? InkWell(
            onTap: () {
              add(item);
              //TODO: Baza daynch
            },
            child: IconInCardTemplate(
                icon: Icons.add, background: AppColors.addButtonBackground),
          )
        : const SizedBox();
  }

  Widget _removeButton(TreeNodeData item) {
    return InkWell(
        onTap: () {
          delete(item);
          //TODO: Baza daynch
        },
        child: IconInCardTemplate(
            icon: Icons.delete, background: AppColors.removeButtonBackground));
  }

  Widget _groupItem(Group group) {
    return GroupItemTemplate(content:
      Container(
        padding: EdgeInsets.all(_paddings),
        child: Text(
          group.name,
          style:
              TextStyle(fontSize: _titleFontSize, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _groupItemExpanded(Group group) {
    return GroupItemTemplate(content:
      Column(
        children: [_groupItemTitle(group), _groupItemContent(group)],
      ),
    );
  }

  Widget _groupItemTitle(Group group) {
    return ItemTitleTemplate(
      widgets: [
        Text(
          group.name,
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: _titleFontSize),
        ),
        InkWell(
          onTap: () => _navigateToGroupDetailPage(group),
          child: IconInCardTemplate(
              icon: Icons.arrow_forward_ios_sharp,
              background: AppColors.navigateArrowBackground,
              foreground: _navigateButtonForeground),
        ),
      ],
    );
  }

  void _navigateToGroupDetailPage(Group group) =>
      Navigator.pushNamed(context, AppUrls.DETAIL_GROUP, arguments: group);

  Widget _groupItemContent(Group group) {
    return ItemContentTemplate(
      widgets: [
        Text(
          group.address.target!.toString(),
        ),
        PropertyInOneRow(
            property: AppStrings.NUMBER_OF_STUDENTS,
            value: group.students.length.toString()),
        PropertyInOneRow(
            property: AppStrings.NUMBER_OF_CLASSES,
            value: group.classes.length.toString())
      ],
    );
  }

  Widget _classesItem(Classes classes) {
    return Card(
      color: _colorsOfTheMonth[classes.dateTime.month],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _borderColor, width: _borderWidth),
        borderRadius: BorderRadius.circular(_cornerEdges),
      ),
      margin: EdgeInsets.symmetric(vertical: _margins),
      elevation: _classesElevation,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - _classesWidth,
        child: Column(
          children: [
            _classesItemTitle(classes),
            _classesItemContent(classes),
          ],
        ),
      ),
    );
  }

  Widget _classesItemTitle(Classes classes) {
    return ItemTitleTemplate(
      widgets: [
        Text(
          formatDate(classes.dateTime),
          style:
              TextStyle(fontSize: _titleFontSize, fontWeight: FontWeight.bold),
        ),
        Text(
          formatTime(classes.dateTime),
          style:
              TextStyle(fontSize: _titleFontSize, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: () => _navigateToClassesDetailPage(classes),
          child: IconInCardTemplate(
              icon: Icons.arrow_forward_ios_sharp,
              background: AppColors.navigateArrowBackground,
              foreground: _navigateButtonForeground),
        ),
      ],
    );
  }

  Widget _classesItemContent(Classes classes) {
    List<Widget> widgets = [];
    widgets.add(
      PropertyInOneRow(
        property: AppStrings.PRESENTS_AT_THE_CLASSSES,
        value: classes.presentStudentsNum.toString(),
      ),
    );
    for (var attendance in classes.attendances) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(attendance.student.target!.introduceYourself()),
            attendance.bill.target!.isPaid
                ? const Icon(Icons.check_box)
                : const Icon(Icons.check_box_outline_blank),
          ],
        ),
      );
    }
    return ItemContentTemplate(widgets: widgets);
  }

  void _navigateToClassesDetailPage(Classes classes) =>
      Navigator.pushNamed(context, AppUrls.DETAIL_CLASSES, arguments: classes);

  Widget _getItem(TreeNodeData data, {bool isExpanded = false}) {
    if (data.object != null) {
      if (data.object is Classes) {
        return _classesItem(data.object);
      }
      if (data.object is Group) {
        return isExpanded
            ? _groupItemExpanded(data.object)
            : _groupItem(data.object);
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
