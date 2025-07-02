import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/dashboard_user_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/target/target_summary_model.dart';


abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}


class DashboardAllLoaded extends DashboardState {
  final DashboardUserResponse userResponse;
  final TargetSummaryModel targetSummary;

  DashboardAllLoaded({
    required this.userResponse,
    required this.targetSummary,
  });
}

// class DashboardLoaded extends DashboardState {
//   final DashboardUserResponse userResponse;

//   DashboardLoaded(this.userResponse);
// }

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}

// class TargetSummaryLoaded extends DashboardState {
//   final TargetSummaryModel targetSummary;
//   TargetSummaryLoaded(this.targetSummary);
// }
