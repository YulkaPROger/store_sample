class VacuumCleaner {
  final String name;
  final List<String> commands;
  final bool isFull;
  final int charge;
  final String serviceDate;

  VacuumCleaner({
    required this.name,
    required this.commands,
    required this.isFull,
    required this.serviceDate,
    required this.charge,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VacuumCleaner &&
          runtimeType == other.runtimeType &&
          commands == other.commands &&
          isFull == other.isFull &&
          charge == other.charge;

  @override
  int get hashCode => commands.hashCode ^ isFull.hashCode ^ charge.hashCode;

  VacuumCleaner copyWith({
     List<String>? commands,
     bool? isFull,
     int? charge,
}) => VacuumCleaner(
      name: name,
      commands: commands ?? this.commands,
      isFull: isFull ?? this.isFull,
      serviceDate: serviceDate,
      charge: charge ?? this.charge);
}
