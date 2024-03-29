// Author: Matthias
import 'exercise.dart';

class ExerciseSetsReps {
  late Exercise exercise;
  late int sets, reps;

  ExerciseSetsReps(this.exercise, this.sets, this.reps);

  ExerciseSetsReps.clone(ExerciseSetsReps exerciseSetsReps)
      : this(exerciseSetsReps.exercise, exerciseSetsReps.sets,
            exerciseSetsReps.reps);

  ExerciseSetsReps.fromJSON(Map<String, dynamic> importMap) {
    exercise = Exercise.fromJSON(importMap['exerciseId'] ?? {});
    sets = importMap['sets'] ?? 0;
    reps = importMap['reps'] ?? 0;
  }

  Map toJSON() => {
        'exerciseId': exercise.toJSON(),
        'sets': sets.toString(),
        'reps': reps.toString()
      };
}
