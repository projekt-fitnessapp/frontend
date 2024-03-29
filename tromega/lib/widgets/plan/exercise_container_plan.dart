// Author: Steffen

import 'package:flutter/material.dart';
import 'package:tromega/widgets/plan/rs_dialog_plan.dart';
import '../../data/classes/exercise_sets_reps.dart';
import './exercise_gif.dart';

class ExerciseContainerPlan extends StatefulWidget {
  //Der Container für die Übungskarten in der Plan Day View

  const ExerciseContainerPlan({Key? key, required this.exercise})
      : super(key: key);
  final ExerciseSetsReps exercise;

  @override
  State<ExerciseContainerPlan> createState() => _ExerciseContainerPlanState();
}

class _ExerciseContainerPlanState extends State<ExerciseContainerPlan>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.65),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Row(children: <Widget>[
              ExerciseGif(gif: widget.exercise.exercise.gifUrl),
              Expanded(
                  child: Column(children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: SizedBox(
                      height: 50,
                      child: Text(widget.exercise.exercise.name,
                          maxLines: 2,
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToLastDescent: true),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall),
                    )),
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      RSDialogPlan(number: widget.exercise.sets, type: "Sätze"),
                      RSDialogPlan(number: widget.exercise.reps, type: "Wdh"),
                    ])),
              ])),
            ])));
  }
}
