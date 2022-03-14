import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/list_items/group_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class DetailClassesType extends StatefulWidget {
  const DetailClassesType({Key? key}) : super(key: key);

  @override
  _DetailClassesTypeState createState() => _DetailClassesTypeState();
}

class _DetailClassesTypeState extends State<DetailClassesType> {
  static const double titleHeight = 200.0;
  late ClassesType _classesType;

  late Stream<List<Group>> _groupStream;
  late Map _args;
  late Function? _parentUpdateFunction;

  @override
  void initState() {
    super.initState();
    _groupStream = ObjectBox.store
        .box<Group>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _parentUpdateFunction = _args[AppStrings.function];
    _classesType = _args[AppStrings.classesType];

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
                    label: AppStrings.addGroup,
                    backgroundColor: Colors.amberAccent,
                    onTap: _navigateToCreateNewGroupPage),
                SpeedDialChild(
                    child: const Icon(Icons.edit),
                    label: AppStrings.edit,
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
              title: '${AppStrings.numberOfGroups}:',
              value: _classesType.groups.length.toString(),
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.priceForMonth}:',
              value:
                  '${_classesType.priceForMonth.toString()}${AppStrings.currency}',
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.priceForEach}:',
              value:
                  '${_classesType.priceForEach.toString()}${AppStrings.currency}',
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.numberOfSignedUp}:',
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
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(
          AppStrings.classesType.toLowerCase(),
          style: Theme.of(context).textTheme.headline2,
        ),
      ],
    );
  }

  void _navigateToCreateNewGroupPage() =>
      Navigator.pushNamed(context, AppUrls.createGroup,
          arguments: {AppStrings.classesType : _classesType,
          AppStrings.function : _addGroup});

  void _addGroup(Group group){
    setState(() {
      group.classesType.target!.addGroup(group);
    });
  }

  void _navigateToEditClassesType() => {
        Navigator.pushNamed(context, AppUrls.editClassesType,
            arguments: {AppStrings.classesType: _classesType,
            AppStrings.function : _updateClassesType})
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
