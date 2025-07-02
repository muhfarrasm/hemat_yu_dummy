import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/auth/me_response_model.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/dashboard_model.dart';
import 'package:hematyu_app_dummy_fix/data/repository/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<FetchDashboard>((event, emit) async {
      emit(DashboardLoading());
      try {
        final profile = await repository.getProfile(event.token);
        final pemasukan = await repository.getTotalPemasukanMonthly(
          event.token,
          event.month,
          event.year,
        );

        emit(DashboardLoaded(
          profile: profile,
          pemasukan: pemasukan,
        ));
      } catch (e) {
        emit(DashboardError(message: e.toString()));
      }
    });
  }
}
