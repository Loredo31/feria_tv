enum ActivityStatus { proximo, enCurso, finalizado, cancelado, reprogramado }

class FeriaActivity {
  final String title;
  final String time;
  final String place;
  final ActivityStatus status;

  const FeriaActivity({
    required this.title,
    required this.time,
    required this.place,
    this.status = ActivityStatus.proximo,
  });
}
