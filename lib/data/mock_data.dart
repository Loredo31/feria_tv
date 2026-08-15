import 'package:mi_feria_inteligente/models/activity.dart';
import 'package:mi_feria_inteligente/models/vote_option.dart';
import 'package:mi_feria_inteligente/models/feria_alert.dart';

const eventName = '';

const currentActivity = FeriaActivity(
  title: '',
  time: '',
  place: '',
  status: ActivityStatus.proximo,
);

const List<FeriaActivity> nextActivities = [];

const List<VoteOption> voteResults = [];

const demoAlert = FeriaAlert(
  message: '',
  instruction: '',
  level: AlertLevel.aviso,
);
