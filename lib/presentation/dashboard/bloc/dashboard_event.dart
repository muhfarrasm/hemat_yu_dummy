part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class FetchDashboard extends DashboardEvent {
  final String token;
  final int month;
  final int year;

  const FetchDashboard({
    required this.token,
    required this.month,
    required this.year,
  });

  @override
  List<Object> get props => [token, month, year];
}
