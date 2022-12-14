import 'package:flutter/material.dart';
import 'package:tromega/data/exerciseSetsReps.dart';
import 'package:tromega/widgets/plan/exercise_container_adding.dart';
import '../../widgets/bottom_menu.dart';
import '../../widgets/shared/app_bar.dart';
import '../../data/trainingDay.dart';
import '../../data/plan_http_helper.dart';

class AddExercise extends StatefulWidget {
  //View zum Hinzufügen von Übungen zu einem Trainingsplan
  final TrainingDay day;
  AddExercise({Key? key, required this.day}) : super(key: key);

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  var exercises = [];

  String searchWord = "";

  late PlanHttpHelper planHttpHelper;
  bool fetching = true;

  @override
  initState() {
    planHttpHelper = PlanHttpHelper();
    fetchData(); //Übungen abfragen
    super.initState();
  }

  //Suche nach Übungen, Muskeln und Equipment
  onSearchTextChanged(String text) {
    List<ExerciseSetsReps> searchResults = [];
    for (var exercise in exercises) {
      if (text == '' ||
          exercise.exercise.name.contains(text) ||
          exercise.exercise.muscle.contains(text) ||
          exercise.exercise.equipment.contains(text)) {
        searchResults.add(exercise);
      }
    }
    return searchResults;
  }

  @override
  Widget build(BuildContext context) {
    var searchResultsExercises = onSearchTextChanged(searchWord);
    var searchController = TextEditingController(text: searchWord);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar_Icon(actions: const []),
      body: fetching
          ? const Center(child: CircularProgressIndicator())
          : Column(children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                    child: IconButton(
                        icon: const Icon(Icons.close),
                        alignment: Alignment.topLeft,
                        iconSize: 32,
                        onPressed: () {
                          Navigator.pop(context);
                        })),
                Expanded(
                    child: IconButton(
                        icon: const Icon(Icons.filter_list_alt),
                        alignment: Alignment.topRight,
                        iconSize: 32,
                        onPressed: () {}))
              ]),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3.0,
                              color: Theme.of(context).primaryColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: TextField(
                          controller: searchController,
                          onSubmitted: (value) {
                            searchWord = value;
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(color: Colors.grey[300]),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.cancel_outlined),
                                  color: Colors.white,
                                  onPressed: (() {
                                    searchController.clear();
                                    searchWord = "";
                                    setState(() {});
                                  }))),
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ))),
              Expanded(
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                    for (var exercise in searchResultsExercises)
                      //Übungskarten
                      ExerciseContainerAdding(
                          exercise: exercise, day: widget.day),
                  ]))
            ]),
      bottomNavigationBar: const BottomMenu(index: 1),
    );
  }

  void fetchData() async {
    List<ExerciseSetsReps> initExercises =
        await planHttpHelper.getExercise(); //Abfragen der Übungen von der API
    setState(() {
      exercises = initExercises;
      fetching = false;
    });
  }
}
