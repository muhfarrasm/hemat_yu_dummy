import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hematyu_app_dummy_fix/data/repository/transaksi_repository.dart';
import 'package:hematyu_app_dummy_fix/data/model/request/transaksi/add_pemasukan_request.dart';
import 'package:hematyu_app_dummy_fix/data/model/request/transaksi/add_pengeluaran_request.dart';
import 'transaksi_event.dart';
import 'transaksi_state.dart';

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  final TransaksiRepository repository;

  TransaksiBloc(this.repository) : super(TransaksiInitial()) {
    on<SubmitPemasukan>((event, emit) async {
      emit(TransaksiLoading());
      try {
        final request = AddPemasukanRequest(
          jumlah: event.data['jumlah'],
          tanggal: event.data['tanggal'],
          kategoriId: event.data['kategori_id'],
          deskripsi: event.data['deskripsi'],
          buktiPath: event.data['bukti_transaksi'],
          lokasi: event.data['lokasi'],
        );
        final response = await repository.addPemasukan(request);
        emit(TransaksiSuccess(response.message));
      } catch (e) {
        emit(TransaksiError(e.toString()));
      }
    });

    on<SubmitPengeluaran>((event, emit) async {
      emit(TransaksiLoading());
      try {
        final request = AddPengeluaranRequest(
          jumlah: event.data['jumlah'],
          tanggal: event.data['tanggal'],
          kategoriId: event.data['kategori_id'],
          deskripsi: event.data['deskripsi'],
          buktiPath: event.data['bukti_transaksi'],
          lokasi: event.data['lokasi'],
        );
        final response = await repository.addPengeluaran(request);
        emit(TransaksiSuccess(response.message));
      } catch (e) {
        emit(TransaksiError(e.toString()));
      }
    });
  }
}
