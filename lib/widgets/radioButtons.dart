import 'package:flutter/material.dart';

class RadioButtons extends StatefulWidget {
  const RadioButtons({
    super.key,
    required this.options,
  });

  final List<String> options;

  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  @override
  Widget build(BuildContext context) {
    var _selection;

    return Column(
      children: [
        for (int i = 1; i < widget.options.length; i++)
          ListTile(
            title: Text(
              widget.options[i],
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            leading: Radio(
              activeColor: Colors.amberAccent,
              value: i,
              groupValue: _selection,
              onChanged: i == 0
                  ? null
                  : (value) {
                      setState(() => _selection = value);
                    },
            ),
          )
      ],
    );
  }
}
