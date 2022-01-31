import 'package:flutter/material.dart';
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
  late Stream<List<ClassesType>> _classesType;

  List<TreeNodeData> _elements = [];
  List<Student> _studentsList = [];

  DateTime selectedDate = DateTime.now(), selectedTime = DateTime.now();

  final Color _classesTypeBackground = Colors.blueGrey.shade400,
      _groupBackground = Colors.blueGrey.shade200,
      _classesBackground = Colors.blueGrey.shade50,
      _borderColor = Colors.grey,
      _addButtonBackground = Colors.green.shade500,
      _removeButtonBackground = Colors.red,
      _iconForegroundColor = Colors.white;

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
      children: [_removeButton(item), _addButton(item)],
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
            child: _icon(Icons.add, _addButtonBackground),
          )
        : const SizedBox();
  }

  Card _icon(IconData icon, Color background) {
    return Card(
      color: background,
      child: Icon(
        icon,
        color: _iconForegroundColor,
        size: _iconSize,
      ),
    );
  }

  Widget _removeButton(TreeNodeData item) {
    return InkWell(
        onTap: () {
          delete(item);
          //TODO: Baza daynch
        },
        child: _icon(Icons.delete, _removeButtonBackground));
  }

  Widget _classesTypeItem(ClassesType classesType) {
    return _classesTypeCard(Text(
      classesType.name,
      style: TextStyle(fontSize: _titleFontSize, fontWeight: FontWeight.w500),
    ));
  }

  Widget _classesTypeItemExpanded(ClassesType classesType) {
    return _classesTypeCard(
      Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: _paddings, bottom: _paddings),
            child: Text(
              classesType.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: _titleFontSize),
            ),
          ),
          _propertyOnRow(Strings.PRICE_FOR_MONTH,
              '${classesType.priceForMonth.toString()}${Strings.CURRENCY}'),
          _propertyOnRow(Strings.PRICE_FOR_EACH,
              '${classesType.priceForEach.toString()}${Strings.CURRENCY}'),
          _propertyOnRow(
              Strings.NUMBER_OF_GROUPS, classesType.groups.length.toString()),
        ],
      ),
    );
  }

  Widget _classesTypeCard(Widget content) {
    return Card(
      elevation: _classesTypeElevation,
      margin: EdgeInsets.all(_margins),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _borderColor, width: _borderWidth),
        borderRadius: BorderRadius.circular(_cornerEdges),
      ),
      color: _classesTypeBackground,
      child: Container(
        width: MediaQuery.of(context).size.width - _classesTypeWidth,
        padding: EdgeInsets.all(_paddings),
        child: content,
      ),
    );
  }

  Widget _propertyOnRow(String propertyName, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(propertyName), Text(value)],
    );
  }

  Widget _groupItemCard(Widget content) {
    return Card(
      elevation: _groupElevation,
      margin: EdgeInsets.all(_margins),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _borderColor, width: _borderWidth),
        borderRadius: BorderRadius.circular(_cornerEdges),
      ),
      color: _groupBackground,
      child: Container(
        width: MediaQuery.of(context).size.width - _groupWidth,
        padding: EdgeInsets.all(_paddings),
        child: content,
      ),
    );
  }

  Widget _groupItemExpanded(Group group) {
    return _groupItemCard(
      Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: _paddings, bottom: _paddings),
            child: Text(
              group.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: _titleFontSize),
            ),
          ),
          Text(
            group.address.target!.toString(),
          ),
          _propertyOnRow(
              Strings.NUMBER_OF_STUDENTS, group.students.length.toString()),
          _propertyOnRow(
              Strings.NUMBER_OF_CLASSES, group.classes.length.toString())
        ],
      ),
    );
  }

  Widget _groupItem(Group group) {
    return _groupItemCard(
      Text(
        group.name,
        style: TextStyle(fontSize: _titleFontSize, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _classesItem(Classes classes) {
    List<Widget> widgets = [];
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
    return Card(
      color: _colorDependsOnDate(classes.dateTime),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _borderColor, width: _borderWidth),
        borderRadius: BorderRadius.circular(_cornerEdges),
      ),
      margin: EdgeInsets.symmetric(vertical: _margins),
      elevation: _classesElevation,
      child: Container(
        padding: EdgeInsets.all(_paddings),
        width: MediaQuery.of(context).size.width - _classesWidth,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(_paddings),
              child: Text(
                '${formatDate(classes.dateTime)} ${formatTime(classes.dateTime)}',
                style: TextStyle(
                    fontSize: _titleFontSize, fontWeight: FontWeight.bold),
              ),
            ),
            _propertyOnRow(
              Strings.PRESENTS_AT_THE_CLASSSES,
              classes.presentStudentsNum.toString(),
            ),
            Column(
              children: widgets,
            )
          ],
        ),
      ),
    );
  }

  Color _colorDependsOnDate(DateTime dateTime){
    switch(dateTime.month)
    {
      case 1:
        return Colors.red.shade200;
      case 2:
        return Colors.blue.shade200;
      case 3:
        return Colors.green.shade200;
      case 4:
        return Colors.yellow.shade200;
      case 5:
        return Colors.orange.shade200;
      case 6:
        return Colors.indigo.shade200;
      case 7:
        return Colors.blueGrey.shade200;
      case 8:
        return Colors.cyan.shade200;
      case 9:
        return Colors.lightGreen.shade200;
      case 10:
        return Colors.amber.shade200;
      case 11:
        return Colors.deepPurple.shade200;
      case 12:
        return Colors.teal.shade200;
      default:
        return Colors.red;
    }
  }

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
            ? _classesTypeItemExpanded(data.object)
            : _classesTypeItem(data.object);
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
