import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldTemplateNum extends StatefulWidget {
  TextFieldTemplateNum({Key? key, required this.label, required this.hint})
      : super(key: key);

  final String label, hint;
  late String input = '';
  late TextEditingController? controller = TextEditingController();

  String get userInput {
    return input;
  }

  void clear() {
    input = '';
    controller!.clear();
  }

  @override
  _TextFieldTemplateNumState createState() => _TextFieldTemplateNumState();
}

class _TextFieldTemplateNumState extends State<TextFieldTemplateNum> {
  @override
  Widget build(BuildContext context) {
    widget.controller ??= TextEditingController();
    return TextField(
      style: Theme.of(context).textTheme.headline2,
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      controller: widget.controller,
      decoration: InputDecoration(
          label:
          Text(widget.label, style: Theme.of(context).textTheme.headline2),
          hintText: widget.hint),
      onChanged: (String str) => str.isNotEmpty ? widget.input = str : {},
    );
  }
}
