import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/list_items/group_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class DetailClassesType extends StatefulWidget {
  DetailClassesType({Key? key}) : super(key: key);

  @override
  _DetailClassesTypeState createState() => _DetailClassesTypeState();
}

class _DetailClassesTypeState extends State<DetailClassesType> {
  static const double titleHeight = 160.0;
  late ClassesType _classesType;
  late Store _store;

  late Stream<List<Group>> _groupStream;
  late Map _args;
  late Function? _parentUpdateFunction;

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _groupStream = _store
        .box<Group>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _parentUpdateFunction = _args[AppStrings.FUNCTION];
    _classesType = _args[AppStrings.CLASSES_TYPE];

    return StreamBuilder<List<Group>>(
      stream: _groupStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _classesType.getFromDb();
          // _classesType = objectBox.store.box<ClassesType>().get(_classesType.id)!;
          return Scaffold(
            floatingActionButton: SpeedDial(
              icon: Icons.settings,
              backgroundColor: Colors.amber,
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.group_add),
                    label: AppStrings.ADD_GROUP,
                    backgroundColor: Colors.amberAccent,
                    onTap: _navigateToCreateNewGroupPage),
                SpeedDialChild(
                    child: const Icon(Icons.edit),
                    label: AppStrings.EDIT,
                    backgroundColor: Colors.amberAccent,
                    onTap: _navigateToEditClassesType),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                _customAppBar(),
                _content(),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      stretch: true,
      onStretchTrigger: () => Future<void>.value(),
      expandedHeight: titleHeight,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _propertiesView(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.5),
                  end: Alignment.center,
                  colors: <Color>[Colors.black12, Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList _content() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => GroupListItemTemplate(
          group: _classesType.groups.elementAt(index),
        ),
        childCount: _classesType.groups.length,
      ),
    );
  }

  SafeArea _propertiesView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Column(
          children: [
            _pageTitle(),
            OneRowPropertyTemplate(
              title: '${AppStrings.NUMBER_OF_GROUPS}:',
              value: _classesType.groups.length.toString(),
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.PRICE_FOR_MONTH}:',
              value:
                  '${_classesType.priceForMonth.toString()}${AppStrings.CURRENCY}',
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.PRICE_FOR_EACH}:',
              value:
                  '${_classesType.priceForEach.toString()}${AppStrings.CURRENCY}',
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.NUMBER_OF_SIGNED_UP}:',
              value: '${_classesType.numberOfStudents()}',
            ),
          ],
        ),
      ),
    );
  }

  Column _pageTitle() {
    return Column(
      children: [
        Text(
          _classesType.name,
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        Text(
          AppStrings.CLASSES_TYPE.toLowerCase(),
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }

  void _navigateToCreateNewGroupPage() =>
      Navigator.pushNamed(context, AppUrls.CREATE_GROUP,
          arguments: {AppStrings.CLASSES_TYPE : _classesType});

  void _navigateToEditClassesType() => {
        Navigator.pushNamed(context, AppUrls.EDIT_CLASSES_TYPE,
            arguments: {AppStrings.CLASSES_TYPE: _classesType,
            AppStrings.FUNCTION : _updateClassesType})
      };

  void _updateClassesType(ClassesType updated){
    if (_parentUpdateFunction != null){
      _parentUpdateFunction!(updated);
    }

    setState(() {
      _classesType = updated;
    });
  }
}
