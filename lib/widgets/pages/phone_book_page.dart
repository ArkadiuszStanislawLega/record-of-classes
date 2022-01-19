import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/widgets/templates/list_items/phone_book_list_item_template.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class PhoneBookPage extends StatefulWidget {
  const PhoneBookPage({Key? key}) : super(key: key);

  @override
  _PhoneBookPageState createState() => _PhoneBookPageState();
}

enum PhonesFiltering {
  alphabeticalAscending,
  alphabeticalDescending,
}

class _PhoneBookPageState extends State<PhoneBookPage> {
  late Stream<List<Phone>> _phonesSteam;
  List<Phone> _phones = [];
  PhonesFiltering _currentPhonesFiltering =
      PhonesFiltering.alphabeticalAscending;

  @override
  void initState() {
    super.initState();
    _phonesSteam = objectBox.store
        .box<Phone>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Phone>>(
      stream: _phonesSteam,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _phones = snapshot.data!;
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                _customAppBar(),
                _content(),
              ],
            ),
            floatingActionButton: SpeedDial(
              icon: Icons.person_add,
              backgroundColor: Colors.amber,
              onPress: () {},
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
      bottom: PreferredSize(
        preferredSize: const Size(0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _pageNavigationButton(
                title: Strings.ALPHABETIC_ASCENDING,
                filtering: PhonesFiltering.alphabeticalAscending),
            _pageNavigationButton(
                title: Strings.ALPHABETIC_DESCENDING,
                filtering: PhonesFiltering.alphabeticalDescending),
          ],
        ),
      ),
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

  DecoratedBox _pageNavigationButton(
      {required String title, required PhonesFiltering filtering}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: _currentPhonesFiltering == filtering
                ? Colors.black12
                : Colors.transparent,
            offset: const Offset(0, -1),
            blurRadius: 4,
          )
        ],
      ),
      child: TextButton(
        onPressed: () => setState(() => _currentPhonesFiltering = filtering),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
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
              child: const Text(
                Strings.PHONE_BOOK,
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            OneRowPropertyTemplate(
              title: '${Strings.NUMBER_OF_PHONES}:',
              value: '${_phones.length}',
            ),
          ],
        ),
      ),
    );
  }

  SliverList _content() => _phonesSliverList();

  SliverList _phonesSliverList() {
    _filterList();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => PhoneBookListItemTemplate(
          phone: _phones.elementAt(index),
        ),
        childCount: _phones.length,
      ),
    );
  }

  void _filterList() {
    _phones.sort((phone1, phone2) =>
        phone1.owner.target!.surname.compareTo(phone2.owner.target!.surname));
    if (_currentPhonesFiltering == PhonesFiltering.alphabeticalDescending) {
      _phones.sort((phone1, phone2) => phone1.owner.target!.surname
                  .compareTo(phone2.owner.target!.surname) ==
              1
          ? 0
          : 1);
    }
  }
}
