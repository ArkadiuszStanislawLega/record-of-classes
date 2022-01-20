import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: Strings.CALL,
          color: Colors.white,
          icon: Icons.phone,
          onTap: _makePhoneCall,
        ),
        IconSlideAction(
            caption: Strings.SEND_MESSAGE,
            color: Colors.yellow,
            icon: Icons.message,
            onTap: _senSMS),
        IconSlideAction(
            caption: Strings.EDIT,
            color: Colors.green,
            icon: Icons.edit,
            onTap: _navigateToEditContact),
        IconSlideAction(
            caption: Strings.DELETE,
            color: Colors.red,
            icon: Icons.delete,
            onTap: _navigateToRemoveContact),
      ],
      child: Card(
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
      ),
    );
  }

  void _navigateToParentProfile() {
    switch (widget.phone.owner.target!.type) {
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

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.phone.number.toString(),
    );
    await launch(launchUri.toString());
  }

  Future<void> _senSMS() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.phone.number.toString(),
    );
    await launch(launchUri.toString());
  }

  void _navigateToEditContact() =>
      Navigator.pushNamed(context, AppUrls.EDIT_PHONE, arguments: widget.phone);

  void _navigateToRemoveContact() => _removePhoneFromDb();

  void _removePhoneFromDb() {
    setState(() {
      widget.phone.owner.target!.phones
          .removeWhere((element) => element.id == widget.phone.id);
      objectBox.store.box<Phone>().remove(widget.phone.id);
    });
    SnackBarInfoTemplate(
        context: context,
        message: '${Strings.REMOVED_FROM_DATABASE} ${Strings.CONTACT}');
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
