import 'package:flutter/material.dart';
import '../data/classes.dart';
import 'package:numberpicker/numberpicker.dart';

class RepsDialog extends StatefulWidget {
  RepsDialog({Key? key, required this.reps, required this.changeReps})
      : super(key: key);
  int reps;
  final ValueChanged<int> changeReps;

  @override
  State<RepsDialog> createState() => _RepsDialogState();
}

class _RepsDialogState extends State<RepsDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          child: Text("${widget.reps} Wdh"),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>
                    StatefulBuilder(builder: (context, setState) {
                      return Dialog(
                          insetPadding: const EdgeInsets.all(150),
                          backgroundColor: Theme.of(context).backgroundColor,
                          child: NumberPicker(
                              textStyle:
                                  Theme.of(context).textTheme.labelMedium,
                              minValue: 0,
                              maxValue: 100,
                              value: widget.reps,
                              onChanged: (int value) {
                                setState(() {});
                                super.setState(() {
                                  widget.reps = value;
                                  widget.changeReps(value);
                                });
                              }));
                    }));
          },
        ));
  }
}