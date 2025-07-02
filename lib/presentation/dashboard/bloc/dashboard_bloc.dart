import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/dashboard_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/dashboard/bloc/dashboard_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc(this.repository) : super(DashboardInitial()) {
    on<FetchDashboardEvent>((event, emit) async {
      emit(DashboardLoading());
      try {
        final userData = await repository.getUserInfo();
        final targetSummary = await repository.getTargetSummary();
        emit(
          DashboardAllLoaded(
            userResponse: userData,
            targetSummary: targetSummary,
          ),
        );
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
