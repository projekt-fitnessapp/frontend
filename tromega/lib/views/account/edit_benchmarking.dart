// Erstellt von Rebekka Miguez //

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tromega/data/classes/benchmarking.dart';
import 'package:tromega/data/classes/stats_pair.dart';
import 'package:tromega/data/http_helper.dart';
import '../../app.dart';
import '../../widgets/account/crunches_dialog.dart';
import '../../widgets/account/pull_dialog.dart';
import '../../widgets/account/squads_dialog.dart';
import '../../widgets/account/push_dialog.dart';
import '../../widgets/shared/app_bar.dart';

class EditBenchmarking extends StatefulWidget {
//View zur Aktualisierung der neuen Benchmarks
  const EditBenchmarking({Key? key}) : super(key: key);

  @override
  State<EditBenchmarking> createState() => _EditBenchmarkingState();
}

class _EditBenchmarkingState extends State<EditBenchmarking> {
  late StatsPair lastPushUps;
  late StatsPair lastPullUps;
  late StatsPair lastSquats;
  late StatsPair lastCrunches;
  late Benchmarking thisPushUps;
  late Benchmarking thisPullUps;
  late Benchmarking thisSquats;
  late Benchmarking thisCrunches;
  late HttpHelper httpHelper;
  late SharedPreferences prefs;
  bool fetching = true;

  // Aktualisierung der neuen Dialog Values der Übungen
  void _changePushUps(pushUps) {
    setState(() => lastPushUps.exerciseAmount = pushUps);
  }

  void _changePullUps(int pullUps) {
    setState(() => lastPullUps.exerciseAmount = pullUps);
  }

  void _changeSquats(int squads) {
    setState(() => lastSquats.exerciseAmount = squads);
  }

  void _changeCrunches(int crunches) {
    setState(() => lastCrunches.exerciseAmount = crunches);
  }

  @override
  void initState() {
    httpHelper = HttpHelper();
    thisPushUps = Benchmarking("", "", "", 0, 0);
    thisPullUps = Benchmarking("", "", "", 0, 0);
    thisSquats = Benchmarking("", "", "", 0, 0);
    thisCrunches = Benchmarking("", "", "", 0, 0);
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBarIcon(
        actions: const [],
      ),
      body: fetching
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Center(
                      child: Text(
                        "Benchmarkings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: color,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Aktualisiere die Anzahl der Übungen",
                        style: TextStyle(
                          fontSize: 18,
                          color: color,
                        ),
                      ),
                    ),
                  ]),
                ),
                // Die Dialoge zur Aktualisierung der Benchmarks
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PushDialog(
                          pushUps: lastPushUps.exerciseAmount,
                          changePushUps: _changePushUps),
                      PullDialog(
                          pullUps: lastPullUps.exerciseAmount,
                          changePullUps: _changePullUps),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SquadsDialog(
                          squads: lastSquats.exerciseAmount,
                          changeSquads: _changeSquats),
                      CrunchesDialog(
                          crunches: lastCrunches.exerciseAmount,
                          changeCrunches: _changeCrunches),
                    ]),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            maximumSize: const Size(200, 50),
                            primary: const Color.fromARGB(1000, 0, 48, 80),
                          ),
                          onPressed: () {
                            // Speicherung der neuen Benchmarkwerte
                            setState(() {
                              thisPushUps.exercise_amount =
                                  lastPushUps.exerciseAmount;
                              thisPushUps.exercise_name = "liegestütze";
                              thisPullUps.exercise_amount =
                                  lastPullUps.exerciseAmount;
                              thisPullUps.exercise_name = "klimmzüge";
                              thisSquats.exercise_amount =
                                  lastSquats.exerciseAmount;
                              thisSquats.exercise_name = "kniebeugen";
                              thisCrunches.exercise_amount =
                                  lastCrunches.exerciseAmount;
                              thisCrunches.exercise_name = "crunches";
                            });
                            // Neue Benchmark Werte senden
                            sendBenchmarking(thisPushUps, thisPullUps,
                                thisSquats, thisCrunches);
                          },
                          child: const Text(
                            'Benchmarking aktualisieren',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
    );
  }

  void sendBenchmarking(Benchmarking pushUps, Benchmarking pullUps,
      Benchmarking squads, Benchmarking crunches) async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId") ?? '';
    pullUps.userId = userId;
    pushUps.userId = userId;
    squads.userId = userId;
    crunches.userId = userId;
    //Post Request der neuen Benchmark Werte
    await Future.wait([
      httpHelper.postBenchmarking(pushUps),
      httpHelper.postBenchmarking(pullUps),
      httpHelper.postBenchmarking(squads),
      httpHelper.postBenchmarking(crunches),
    ]);
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => App(currentIndex: 4),
        ));
  }

  //Aktuelle Benchmarkwerte erhalten
  void fetchData() async {
    prefs = await SharedPreferences.getInstance();
    List<dynamic> pushUps = await httpHelper.getBenchmarking("liegestütze");
    List<dynamic> pullUps = await httpHelper.getBenchmarking("klimmzüge");
    List<dynamic> squads = await httpHelper.getBenchmarking("kniebeugen");
    List<dynamic> crunches = await httpHelper.getBenchmarking("crunches");

    setState(() {
      lastPushUps =
          pushUps.isEmpty ? StatsPair(0, DateTime(2023)) : pushUps.last;
      lastPullUps =
          pullUps.isEmpty ? StatsPair(0, DateTime(2023)) : pullUps.last;
      lastSquats = squads.isEmpty ? StatsPair(0, DateTime(2023)) : squads.last;
      lastCrunches =
          crunches.isEmpty ? StatsPair(0, DateTime(2023)) : crunches.last;
      fetching = false;
    });
  }

  void showInSnackbar(BuildContext context, String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        content: Text(value),
      ),
    );
  }
}
