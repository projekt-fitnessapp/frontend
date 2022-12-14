import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:tromega/widgets/tracking/interactives/finish_training_button.dart';
import 'package:tromega/widgets/tracking/interactives/pause_timer.dart';
import 'package:tromega/widgets/tracking/interactives/training_options_button.dart';
import '../../data/training_session.dart';
import '../../data/tracking_http_helper.dart';
import '../../widgets/shared/app_bar.dart';
import '../../widgets/tracking/displays/execution_page.dart';
import '../../widgets/tracking/interactives/exercise_thumbnail.dart';

class TrackingView extends StatefulWidget {
  const TrackingView({Key? key, required this.trainingDayId}) : super(key: key);
  final String trainingDayId;
  @override
  State<TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<TrackingView> {
  late TrainingSession lastSession;
  late TrainingSession thisSession;
  late TrackingHttpHelper trackingHttpHelper;
  late CustomTimerController _timerController;
  late String trainingDayId;
  bool trainingFinished = false;
  bool fetching = true;
  int highlightedPage = 0;


  final PageController _pageController = PageController(initialPage: 0);

  @override
  initState() {
    /// hardcoded for debugging purposes
    trainingDayId = widget.trainingDayId;
    trackingHttpHelper = const TrackingHttpHelper();
    _timerController = CustomTimerController();
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar_Icon(
        actions: fetching
            ? []
            : [
                TrainingOptionsButton(thisSession: thisSession),
              ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: fetching
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: false,
                    itemCount: thisSession.executions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExerciseThumbnail(
                        gifUrl: thisSession.executions[index].exercise.gifUrl,
                        onTapCallback: () {
                          _pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                          setState(() {
                            highlightedPage = index;
                          });
                        },
                        isHighlighted: index == highlightedPage,
                        isDone: thisSession.executions[index].done,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        physics: const PageScrollPhysics(),
                        itemCount: thisSession.executions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ExecutionPage(
                            execution: thisSession.executions[index],
                            trainingDayId: trainingDayId,
                            position: index,
                            toNextExecution: () {
                              int nextPage = getNextToDo(index);
                              if (nextPage != -1) {
                                _pageController.animateToPage(
                                  nextPage,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                );
                                setState(() {
                                  highlightedPage = nextPage;
                                });
                              } else {
                                setState(() {
                                  trainingFinished = true;
                                });
                              }
                            },
                            onFinishSet: () {
                              _timerController.reset();
                              _timerController.start();
                            },
                            onRebuild: () {
                              setState(() {
                                if (getNextToDo(0) == -1) {
                                  trainingFinished = true;
                                } else {
                                  trainingFinished = false;
                                }
                              });
                            },
                          );
                        },
                      ),
                      Visibility(
                        visible: !trainingFinished,
                        child: PauseTimer(
                          controller: _timerController,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: trainingFinished,
                  child: FinishTrainingButton(
                    trainingFinished: trainingFinished,
                    thisSession: thisSession,
                  ),
                ),
              ],
            ),
    );
  }

  void fetchData() async {
    // hard coded for now
    TrainingSession initSession =
        await trackingHttpHelper.getLastSession(trainingDayId);
    setState(() {
      lastSession = initSession;
      thisSession = TrainingSession.clone(initSession);
      fetching = false;
    });
  }

  int getNextToDo(int index) {
    int nextPage =
        thisSession.executions.indexWhere((elem) => elem.done == false, index);
    if (nextPage != -1) {
      return nextPage;
    } else {
      return thisSession.executions.indexWhere((elem) => elem.done == false);
    }
  }
}
