import 'package:flutter/material.dart';

class TextFieldTemplate extends StatefulWidget {
  TextFieldTemplate({Key? key, required this.label, required this.hint})
      : super(key: key);

  final String label, hint;
  late String input=hint;
  late TextEditingController? controller = TextEditingController();

  String get userInput {
    return input;
  }

  void clear() {
    input = '';
    controller!.clear();
  }

  @override
  _TextFieldTemplateState createState() => _TextFieldTemplateState();
}

class _TextFieldTemplateState extends State<TextFieldTemplate> {
  @override
  Widget build(BuildContext context) {
    widget.controller ??= TextEditingController();
    return TextField(
      style: Theme.of(context).textTheme.headline2,
      controller: widget.controller,
      decoration: InputDecoration(
          label:
              Text(widget.label, style: Theme.of(context).textTheme.headline2),
          hintText: widget.hint),
      onChanged: (String str) => str.isNotEmpty ? widget.input = str : {},
    );
  }
}
