import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
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
  final List<Phone> _filteredPhones = [];
  PhonesFiltering _currentPhonesFiltering =
      PhonesFiltering.alphabeticalAscending;

  bool _wasNotInitialized = true;

  static const titleHeight = 220.0;

  @override
  void initState() {
    super.initState();
    _phonesSteam = ObjectBox.store
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
          if (_wasNotInitialized) _filteringList('');

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
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: TextField(
                style: Theme.of(context).textTheme.headline2,
                onChanged: (input) {
                  _filteringList(input);
                },
                decoration: InputDecoration(
                  label: Text(AppStrings.findContact,
                      style: Theme.of(context).textTheme.headline2),
                ),
              ),
            ),
            _pageNavigationButton(
                title: AppStrings.alphabeticAscending,
                filtering: PhonesFiltering.alphabeticalAscending),
            _pageNavigationButton(
                title: AppStrings.alphabeticDescending,
                filtering: PhonesFiltering.alphabeticalDescending),
          ],
        ),
      ),
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

  void _filteringList(String input) {
    if (_wasNotInitialized) {
      for (var element in _phones) {
        _filteredPhones.add(element);
      }
      _wasNotInitialized = false;
    } else {
      setState(() {
        _filteredPhones.clear();
        if (input != '') {
          for (var element in _phones) {
            if (element.owner.target!.surname.contains(input)) {
              _filteredPhones.add(element);
            }
          }
        } else {
          for (var element in _phones) {
            _filteredPhones.add(element);
          }
        }
      });
    }
  }

  SliverList _phonesSliverList() {
    _filterList();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => PhoneBookListItemTemplate(
          phone: _filteredPhones.elementAt(index),
          updateParent: _updateModel,
          removeParent: _removePhone,
        ),
        childCount: _filteredPhones.length,
      ),
    );
  }

  void _removePhone(Phone phone) {
    setState(() {
      _filteredPhones.removeWhere((element) => element.id == phone.id);
    });
  }

  void _updateModel(Phone updated) {
    Phone selectedPhone =
        _phones.firstWhere((element) => element.id == updated.id);
    setState(() {
      selectedPhone = updated;
    });
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
      child: IconButton(
        icon: Icon(filtering == PhonesFiltering.alphabeticalDescending
            ? Icons.arrow_drop_down_sharp
            : Icons.arrow_drop_up_sharp,
        color: Colors.white,),
        onPressed: () => setState(() => _currentPhonesFiltering = filtering),
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
                AppStrings.phoneBook,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.numberOfPhones}:',
              value: '${_phones.length}',
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.numberOfStudentContacts}:',
              value: '${_numberOfStudentsContacts()}',
            ),
            OneRowPropertyTemplate(
              title: '${AppStrings.numberOfParentsContacts}:',
              value: '${_numberOfParentsContacts()}',
            ),
          ],
        ),
      ),
    );
  }

  int _numberOfStudentsContacts() {
    int number = 0;
    for (var element in _phones) {
      if (element.owner.target!.type == PersonType.student) {
        number++;
      }
    }
    return number;
  }

  int _numberOfParentsContacts() {
    int number = 0;
    for (var element in _phones) {
      if (element.owner.target!.type == PersonType.parent) {
        number++;
      }
    }
    return number;
  }

  SliverList _content() => _phonesSliverList();

  void _filterList() {
    _filteredPhones.sort((phone1, phone2) =>
        phone1.owner.target!.surname.compareTo(phone2.owner.target!.surname));
    if (_currentPhonesFiltering == PhonesFiltering.alphabeticalDescending) {
      _filteredPhones.sort((phone1, phone2) => phone1.owner.target!.surname
                  .compareTo(phone2.owner.target!.surname) ==
              1
          ? 0
          : 1);
    }
  }
}
