import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/dashboard_user_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardUserResponse userResponse;

  DashboardLoaded(this.userResponse);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
