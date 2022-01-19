import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/models/phone.dart';

class PhoneBookListItemTemplate extends StatefulWidget {
  PhoneBookListItemTemplate({Key? key, required this.phone}) : super(key: key);
  Phone phone;

  @override
  _PhoneBookListItemTemplateState createState() =>
      _PhoneBookListItemTemplateState();
}

class _PhoneBookListItemTemplateState extends State<PhoneBookListItemTemplate> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 7,
      child: ListTile(
        title: Text(widget.phone.number.toString()),
        subtitle: Text(widget.phone.owner.target!.introduceYourself()),
        onTap: _navigateToParentProfile,
      ),
    );
  }

  void _navigateToParentProfile() {
    Navigator.pushNamed(context, AppUrls.DETAIL_PARENT,
        arguments: widget.phone.owner.target!);

  }

}
