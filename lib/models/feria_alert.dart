enum AlertLevel { emergencia, aviso }

class FeriaAlert {
  final String message;
  final String instruction;
  final AlertLevel level;

  const FeriaAlert({
    required this.message,
    required this.instruction,
    this.level = AlertLevel.aviso,
  });
}
