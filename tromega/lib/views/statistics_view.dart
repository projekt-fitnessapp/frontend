// Author: Maik

import 'package:flutter/material.dart';
import 'package:tromega/views/stats/graph.dart';
import '../../widgets/shared/app_bar.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class StatisticsView extends StatefulWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarIcon(
        actions: const [],
      ),
      body: ListView(
        shrinkWrap: true,
        children: const [
          // Creates a graph for the given exercise
          Graph(exercise: "Liegestütze"),
          Graph(exercise: "Klimmzüge"),
          Graph(exercise: "Kniebeugen"),
          Graph(exercise: "Crunches"),
        ],
      ),
    );
  }
}
