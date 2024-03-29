import 'package:flutter/material.dart';

class PropertyInOneRow extends StatelessWidget {
  const PropertyInOneRow(
      {Key? key, required this.property, required this.value})
      : super(key: key);
  final String property, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          property,
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headline2,
        )
      ],
    );
  }
}
