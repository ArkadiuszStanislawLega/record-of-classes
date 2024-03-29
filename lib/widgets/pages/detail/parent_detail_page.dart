import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/widgets/templates/one_row_property_template.dart';

class ParentDetailPage extends StatefulWidget {
  const ParentDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ParentDetailPage();
  }
}

enum ListsOnPages { children, contacts }

class _ParentDetailPage extends State<ParentDetailPage> {
  late Parent _parent;
  ListsOnPages _currentList = ListsOnPages.contacts;

  @override
  Widget build(BuildContext context) {
    _parent = ModalRoute.of(context)!.settings.arguments as Parent;
    _parent.getFromDb();

    return Scaffold(
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        backgroundColor: Colors.amber,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.phone),
              label: AppStrings.addContact,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToAddPhone),
          SpeedDialChild(
              child: const Icon(Icons.edit),
              label: AppStrings.edit,
              backgroundColor: Colors.amberAccent,
              onTap: _navigateToEditParent),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          _customAppBar(),
          _content(),
        ],
      ),
    );
  }

  void _navigateToEditParent() =>
      Navigator.pushNamed(context, AppUrls.editParent, arguments: _parent);

  void _navigateToAddPhone() =>
      Navigator.pushNamed(context, AppUrls.addPhone, arguments: _parent);

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: const Size(0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _pageNavigationButton(
                title: AppStrings.contacts, page: ListsOnPages.contacts),
            _pageNavigationButton(
                title: AppStrings.children, page: ListsOnPages.children),
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
      {required String title, required ListsOnPages page}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: _currentList == page ? Colors.black12 : Colors.transparent,
            offset: const Offset(0, -1),
            blurRadius: 4,
          )
        ],
      ),
      child: TextButton(
        onPressed: () => setState(() => _currentList = page),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  SliverList _content() => _pageNavigator();

  SliverList _pageNavigator() {
    switch (_currentList) {
      case ListsOnPages.children:
        return _childrenSliverList();
      case ListsOnPages.contacts:
        return _contactsSliverList();
    }
  }

  SliverList _childrenSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 7,
          child: ListTile(
            title: Text(_parent.children.elementAt(index).introduceYourself()),
            subtitle: Text(
                '${AppStrings.toPay}: ${_parent.children.elementAt(index).account.target!.countUnpaidBillsPrice()}${AppStrings.currency}'),
          ),
        ),
        childCount: _parent.children.length,
      ),
    );
  }

  SliverList _contactsSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => _phoneListItem(index),
        childCount: _parent.person.target!.phones.length,
      ),
    );
  }

  SafeArea _propertiesView() {
    double toPay = 0.0;
    for (var child in _parent.children) {
      toPay += child.account.target!.countUnpaidBillsPrice();
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pageTitleContainer(),
            OneRowPropertyTemplate(
              title: '${AppStrings.toPay}:',
              value: '$toPay${AppStrings.currency}',
            ),
          ],
        ),
      ),
    );
  }

  Container _pageTitleContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        _parent.introduceYourself(),
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  Widget _phoneListItem(int index) {
    Phone phone = _parent.person.target!.phones.elementAt(index);

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 7,
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
              caption: AppStrings.delete,
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                setState(() {
                  _parent.person.target!.phones.remove(phone);
                  phone.removeFromDb();
                });
              }),
        ],
        child: Card(
          child: ListTile(
            title: Text(phone.number.toString()),
            subtitle: Text(phone.numberName),
          ),
        ),
      ),
    );
  }
}
