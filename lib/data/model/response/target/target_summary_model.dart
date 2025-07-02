class TargetSummaryModel {
  final int totalTarget;
  final int activeTargets;
  final double totalNeeded;
  final double totalCollected;
  final double percentageCollected;

  TargetSummaryModel({
    required this.totalTarget,
    required this.activeTargets,
    required this.totalNeeded,
    required this.totalCollected,
    required this.percentageCollected,
  });

  factory TargetSummaryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return TargetSummaryModel(
      totalTarget: data['total_target'],
      activeTargets: data['active_targets'],
      totalNeeded: (data['total_needed'] as num).toDouble(),
      totalCollected: (data['total_collected'] as num).toDouble(),
      percentageCollected: (data['percentage_collected'] as num).toDouble(),
    );
  }
}
