// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class RadioButtons extends StatefulWidget {
  RadioButtons({
    super.key,
    required this.options,
    required this.selection,
  });

  final List<String> options;
  int selection;

  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  @override
  Widget build(BuildContext context) {
    // int _selection = 2;

    void radioChange(value) {
      setState(() {
        widget.selection = value;
        print('selection =============== ${widget.selection}');
        print('value =============== $value');
      });
    }

    return Column(
      children: [
        for (int i = 1; i < widget.options.length; i++)
          RadioListTile(
            value: i,
            groupValue: widget.selection,
            onChanged: radioChange,
            title: Text(
              widget.options[i],
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        // ListTile(
        //   title: Text(
        //     widget.options[i],
        //     style: const TextStyle(
        //       color: Colors.white,
        //     ),
        //   ),
        //   leading: Radio(
        //     activeColor: Colors.amberAccent,
        //     value: i,
        //     groupValue: _selection,
        //     onChanged: (value) {
        //       print('============== $_selection');
        //       setState(() {
        //         _selection = value;
        //       });
        //     },
        //   ),
        // )
      ],
    );
  }
}
