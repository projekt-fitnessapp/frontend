import 'package:flutter/material.dart';
import 'package:tromega/data/tracking_http_helper.dart';
import '../../../data/training_session.dart';

class FinishTrainingButton extends StatelessWidget {
  const FinishTrainingButton({super.key, required this.trainingFinished, required this.thisSession});
  final bool trainingFinished;
  final TrainingSession thisSession;
  final TrackingHttpHelper _trackingHttpHelper = const TrackingHttpHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
      child: ElevatedButton(
        onPressed: trainingFinished
            ? () {
                _trackingHttpHelper.saveSession(thisSession).then((value) {
                  if (value) {
                    showInSnackbar(context, 'Training Gespeichert');
                    Navigator.popAndPushNamed(context, '/home');
                  } else {
                    showInSnackbar(context, 'Speichern fehlgeschlagen');
                  }
                });
              }
            : null,
        child: SizedBox(
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              'Training Abschließen',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
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
