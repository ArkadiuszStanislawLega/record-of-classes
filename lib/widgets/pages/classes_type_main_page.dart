import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_doubles.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/list_items/classes_type_list_item.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class ClassesTypeMainPage extends StatefulWidget {
  const ClassesTypeMainPage({Key? key}) : super(key: key);

  @override
  _ClassesTypeMainPageState createState() => _ClassesTypeMainPageState();
}

class _ClassesTypeMainPageState extends State<ClassesTypeMainPage> {
  static const double titleHeight = 150.0;
  late Stream<List<ClassesType>> _classesTypesStream;
  List<ClassesType> _classesTypes = [];

  @override
  void initState() {
    super.initState();
    _classesTypesStream = ObjectBox.store
        .box<ClassesType>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ClassesType>>(
      stream: _classesTypesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _classesTypes = snapshot.data!;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              floatingActionButton: SpeedDial(
                icon: Icons.add,
                backgroundColor: Colors.amber,
                onPress: _navigateToAddNewClassPage,
              ),
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

  void _navigateToAddNewClassPage() =>
      Navigator.pushNamed(context, AppUrls.CREATE_CLASSES_TYPE);

  SliverList _content() => _classesTypesSliverList();

  SliverList _classesTypesSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => ClassesTypeListItem(
          classesType: _classesTypes.elementAt(index),
        ),
        childCount: _classesTypes.length,
      ),
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
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 20.0),
                child: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(bottom: AppDoubles.paddings),
                      child: Text(
                        AppStrings.manageClassTypes,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    OneRowPropertyTemplate(
                      title: '${AppStrings.numberOfClassesType}:',
                      value: _classesTypes.length.toString(),
                    ),
                  ],
                ),
              ),
            ),
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
}
