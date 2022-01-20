import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
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
      color: _colorDependsOnOwnerType(),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 7,
      child: ListTile(
        title: Text(widget.phone.number.toString()),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.phone.owner.target!.introduceYourself()),
            Text(ConverterPersonTypeToString(widget.phone.owner.target!.type))
          ],
        ),
        onTap: _navigateToParentProfile,
      ),
    );
  }

  void _navigateToParentProfile() {
    switch(widget.phone.owner.target!.type){
      case PersonType.none:
        break;
      case PersonType.student:
        Navigator.pushNamed(context, AppUrls.DETAIL_STUDENT,
            arguments: widget.phone.owner.target!.student.target);
        break;
      case PersonType.parent:
        Navigator.pushNamed(context, AppUrls.DETAIL_PARENT,
            arguments: widget.phone.owner.target!.parent.target);
        break;
      case PersonType.teacher:
        break;

    }
  }

  Color _colorDependsOnOwnerType() {
    switch (widget.phone.owner.target!.type) {
      case PersonType.none:
        return Colors.red;
      case PersonType.teacher:
        return Colors.deepPurpleAccent.shade100;
      case PersonType.student:
        return Colors.blue;
      case PersonType.parent:
        return Colors.white38;
    }
  }
}
