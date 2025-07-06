import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/kategori/kategori_response.dart';
import 'package:hematyu_app_dummy_fix/data/repository/kategori_repository.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_event.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_state.dart';
import 'package:hematyu_app_dummy_fix/presentation/kategori/bloc/kategori_type.dart';
class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  final KategoriRepository repository;

  KategoriBloc(this.repository) : super(KategoriInitial()) {
    on<FetchKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        List<KategoriResponse> kategori;

        switch (event.type) {
          case JenisKategori.pemasukan:
            kategori = await repository.getKategoriPemasukan();
            break;
          case JenisKategori.pengeluaran:
            kategori = await repository.getKategoriPengeluaran();
            break;
          case JenisKategori.target:
            kategori = await repository.getKategoriTarget();
            break;
        }

        emit(KategoriLoaded(kategori));
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    on<AddKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.createKategori(
          type: event.type,
          nama: event.nama,
          deskripsi: event.deskripsi,
          anggaran: event.anggaran,
        );
        add(FetchKategori(event.type));
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    on<UpdateKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.updateKategori(
          type: event.type,
          id: event.id,
          nama: event.nama,
          deskripsi: event.deskripsi,
          anggaran: event.anggaran,
        );
        add(FetchKategori(event.type));
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    on<DeleteKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.deleteKategori(type: event.type, id: event.id);
        add(FetchKategori(event.type));
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });
  }
}
