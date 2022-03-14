import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldTemplateDouble extends StatefulWidget {
  TextFieldTemplateDouble({Key? key, required this.label, required this.hint})
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
  _TextFieldTemplateDoubleState createState() => _TextFieldTemplateDoubleState();
}

class _TextFieldTemplateDoubleState extends State<TextFieldTemplateDouble> {
  @override
  Widget build(BuildContext context) {
    widget.controller ??= TextEditingController();
    return TextField(
      style: Theme.of(context).textTheme.headline2,
      keyboardType: const  TextInputType.numberWithOptions(decimal: true, signed: false),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter(RegExp(r'[0-9.,]'), allow: true),
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
