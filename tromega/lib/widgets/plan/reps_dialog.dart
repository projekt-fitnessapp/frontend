// Author: Steffen
import 'package:flutter/material.dart';
import 'package:tromega/widgets/tracking/Dialogs/bottom_dialog_picker.dart';

class RepsDialog extends StatefulWidget {
  //Dialog und Button für die Auswahl der Wiederholungen in der Edit Training View

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
            //Dialog mit Number Picker
            showModalBottomSheet(
                context: context,
                builder: (context) =>
                    StatefulBuilder(builder: (context, setState) {
                      return BottomDialogPicker(
                          title: "Wiederholungen",
                          forReps: true,
                          startValue: widget.reps,
                          onSubmit: (int value) {
                            //Aktualisierung der Satzanzahl im Trainingsplan
                            setState(() {});
                            super.setState(() {
                              widget.reps = value;
                              widget.changeReps(value);
                            });
                          });
                    }));
          },
        ));
  }
}
