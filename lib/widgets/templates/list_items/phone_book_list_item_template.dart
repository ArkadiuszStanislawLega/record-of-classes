import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneBookListItemTemplate extends StatefulWidget {
  PhoneBookListItemTemplate(
      {Key? key, required this.phone, this.updateParent, this.removeParent})
      : super(key: key);
  Phone phone;
  Function? updateParent, removeParent;

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
        _phoneActions(
            icon: Icons.phone,
            title: AppStrings.CALL,
            onTapFunction: _makePhoneCall,
            background: Colors.blue),
        _phoneActions(
            icon: Icons.message,
            title: AppStrings.SEND_MESSAGE,
            onTapFunction: _sendSMS,
            background: Colors.black26),
        _phoneActions(
            icon: Icons.edit,
            title: AppStrings.EDIT,
            onTapFunction: _navigateToEditContact,
            background: Colors.green),
        _phoneActions(
            icon: Icons.delete,
            title: AppStrings.DELETE,
            onTapFunction: _navigateToRemoveContact,
            background: Colors.red)
      ],
      child: Card(
        color: _colorDependsOnOwnerType(),
        elevation: 7,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.phone.number.toString()),
              Text(widget.phone.numberName)
            ],
          ),
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

  IconSlideAction _phoneActions(
      {required IconData icon,
      required String title,
      required Function? onTapFunction,
      required Color background}) {
    return IconSlideAction(
      icon: icon,
      caption: title,
      color: background,
      onTap: onTapFunction as void Function(),
    );
  }

  void _navigateToParentProfile() {
    switch (widget.phone.owner.target!.type) {
      case PersonType.none:
        break;
      case PersonType.student:
        Navigator.pushNamed(context, AppUrls.DETAIL_STUDENT, arguments: {
          AppStrings.STUDENT: widget.phone.owner.target!.student.target
        });
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

  Future<void> _sendSMS() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.phone.number.toString(),
    );
    await launch(launchUri.toString());
  }

  void _navigateToEditContact() =>
      Navigator.pushNamed(context, AppUrls.EDIT_PHONE, arguments: {
        AppStrings.PHONE_NUMBER: widget.phone,
        AppStrings.FUNCTION: _updateModel
      });

  void _updateModel(Phone updated) {
    setState(() {
      widget.phone = updated;
    });

    if (widget.updateParent != null) {
      widget.updateParent!(updated);
    }
  }

  void _navigateToRemoveContact() {
    _removeInParent();
    _removePhoneFromDb();
  }

  void _removeInParent() => widget.removeParent!(widget.phone);

  void _removePhoneFromDb() {
    setState(() {
      widget.phone.removeFromDb();
    });
    SnackBarInfoTemplate(
        context: context,
        message: '${AppStrings.REMOVED_FROM_DATABASE} ${AppStrings.CONTACT}');
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
