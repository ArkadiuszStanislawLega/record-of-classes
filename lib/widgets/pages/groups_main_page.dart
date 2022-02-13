import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/list_items/group_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class GroupsMainPage extends StatefulWidget {
  const GroupsMainPage({Key? key}) : super(key: key);

  @override
  _GroupsMainPageState createState() => _GroupsMainPageState();
}

class _GroupsMainPageState extends State<GroupsMainPage> {
  late Stream<List<Group>> _groupsStream;
  List<Group> _groupsList = [];

  @override
  void initState() {
    super.initState();
    _groupsStream = objectBox.store
        .box<Group>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Group>>(
      stream: _groupsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _groupsList = objectBox.store.box<Group>().getAll();
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  _customAppBar(),
                  _content(),
                ],
              ),
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
      expandedHeight: 200.0,
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

  SafeArea _propertiesView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppStrings.MANAGE_GROUPS,
                style: Theme.of(context).textTheme.headline1,
              ),

            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.NUMBER_OF_GROUPS}:',
              value: '${_groupsList.length}',
            ),
          ],
        ),
      ),
    );
  }

  SliverList _content() => _parentsSliverList();

  SliverList _parentsSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => GroupListItemTemplate(
          group: _groupsList.elementAt(index),
        ),
        childCount: _groupsList.length,
      ),
    );
  }
}
