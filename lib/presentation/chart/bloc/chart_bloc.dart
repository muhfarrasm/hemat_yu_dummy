import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/chart/ringkasan_katpeng_pie_response.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/chart/harian_katpeng_line_response.dart';
import 'package:hematyu_app_dummy_fix/data/repository/chart_repository.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final ChartRepository repository;
  final String token;

  ChartBloc({
    required this.repository,
    required this.token,
  }) : super(ChartInitial()) {
    on<FetchRingkasanKatPengPie>((event, emit) async {
      emit(ChartLoading());
      try {
        final data = await repository.getRingkasanKatPengPie(
          token: token, // ✅ GUNAKAN TOKEN DI SINI!
          month: event.month,
          year: event.year,
        );
        emit(ChartLoadedPie(pieData: data));
      } catch (e) {
        emit(ChartError(message: e.toString()));
      }
    });

    on<FetchHarianKatPengLine>((event, emit) async {
      emit(ChartLoading());
      try {
        final data = await repository.getHarianKatPengLine(
          token: token, // ✅
          kategoriId: event.kategoriId,
          month: event.month,
          year: event.year,
        );
        emit(ChartLoadedLine(lineData: data));
      } catch (e) {
        emit(ChartError(message: e.toString()));
      }
    });
  }
}
