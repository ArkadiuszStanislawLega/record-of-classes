import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/widgets/templates/list_items/classes_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class ClassesMainPage extends StatefulWidget {
  const ClassesMainPage({Key? key}) : super(key: key);

  @override
  _ClassesMainPageState createState() => _ClassesMainPageState();
}

class _ClassesMainPageState extends State<ClassesMainPage> {
  late Store _store;
  late Stream<List<Classes>> _classesStream;
  List<Classes> _classesList = [];
  static const double titleHeight = 200.0;

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _classesStream = _store
        .box<Classes>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Classes>>(
      stream: _classesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _classesList = objectBox.store.box<Classes>().getAll();
          return Scaffold(
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

  SliverList _content() => _classesSliverList();

  SliverList _classesSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => ClassesListItemTemplate(
          classes: _classesList.elementAt(index),
          removeFromDbFunction: _removeClassesFromDb,
        ),
        childCount: _classesList.length,
      ),
    );
  }

  void _removeClassesFromDb(Classes classes){
    setState(() {
      classes.removeFromDb();
    });
  }

  SafeArea _propertiesView() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                Strings.MANAGE_CLASSES,
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            OneRowPropertyTemplate(
              title: '${Strings.NUMBER_OF_CLASSES}:',
              value: _classesList.length.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
