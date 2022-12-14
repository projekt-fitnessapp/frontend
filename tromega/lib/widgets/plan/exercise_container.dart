import 'package:flutter/material.dart';
import '../../data/exerciseSetsReps.dart';
import 'sets_dialog.dart';
import 'reps_dialog.dart';
import 'exercise_gif.dart';

class ExerciseContainer extends StatefulWidget {
  //Der Container für die Übungskarten in der  Edit Training View

  const ExerciseContainer(
      {Key? key,
      required this.exercises,
      required this.indexExercise,
      required this.update})
      : super(key: key);
  final List<ExerciseSetsReps> exercises;
  final int indexExercise;
  final ValueChanged<int> update;

  @override
  State<ExerciseContainer> createState() => _ExerciseContainerState();
}

class _ExerciseContainerState extends State<ExerciseContainer>
    with TickerProviderStateMixin {
  void _changeSets(int sets) {
    setState(() => widget.exercises[widget.indexExercise].sets = sets);
  }

  void _changeReps(int reps) {
    setState(() => widget.exercises[widget.indexExercise].reps = reps);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.indexExercise < widget.exercises.length) {
      var exercise = widget.exercises[widget.indexExercise];
      return Container(
          height: 120,
          margin:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
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
                ExerciseGif(gif: exercise.exercise.gifUrl),
                Expanded(
                    child: Column(children: <Widget>[
                  IntrinsicHeight(
                    child: Row(children: [
                      Flexible(
                        flex: 9,
                        fit: FlexFit.tight,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Text(exercise.exercise.name,
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineSmall)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.close),
                              alignment: Alignment.topRight,
                              iconSize: 15,
                              onPressed: () {
                                //Löscehn von ausgewählten Übungen und Aktualisierung
                                widget.exercises.remove(exercise);
                                setState(() {});
                                widget.update(100);
                              }),
                        ],
                      ),
                    ]),
                  ),
                  Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        SetsDialog(
                            sets: widget.exercises[widget.indexExercise].sets,
                            changeSets: _changeSets),
                        RepsDialog(
                            reps: widget.exercises[widget.indexExercise].reps,
                            changeReps: _changeReps),
                      ])),
                ])),
              ])));
    } else {
      return Container();
    }
  }
}
