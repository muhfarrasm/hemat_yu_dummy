import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/kategori_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  final KategoriRepository repository;

  KategoriBloc(this.repository) : super(KategoriInitial()) {
    on<FetchKategoriPemasukan>((event, emit) async {
      emit(KategoriLoading());
      try {
        final kategori = await repository.getKategoriPemasukan();
        emit(KategoriLoaded(kategori));
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    on<FetchKategoriPengeluaran>((event, emit) async {
      emit(KategoriLoading());
      try {
        final kategori = await repository.getKategoriPengeluaran();
        emit(KategoriLoaded(kategori));
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });
  }
}
