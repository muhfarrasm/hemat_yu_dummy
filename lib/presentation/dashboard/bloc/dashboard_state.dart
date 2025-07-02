part of 'dashboard_bloc.dart';


abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final MeResponseModel profile;
  final TotalPemasukanResponse pemasukan;

  const DashboardLoaded({
    required this.profile,
    required this.pemasukan,
  });

  @override
  List<Object> get props => [profile, pemasukan];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
