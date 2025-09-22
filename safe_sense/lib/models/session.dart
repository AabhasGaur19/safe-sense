class Session {
  final DateTime startTime;
  final DateTime endTime;
  final String startLocation;
  final String endLocation;
  final Duration duration;

  Session({
    required this.startTime,
    required this.endTime,
    required this.startLocation,
    required this.endLocation,
  }) : duration = endTime.difference(startTime);
}