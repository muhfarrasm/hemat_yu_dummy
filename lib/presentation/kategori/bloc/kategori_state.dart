import 'package:hematyu_app_dummy_fix/data/model/response/kategori/kategori_response.dart';

abstract class KategoriState {}

class KategoriInitial extends KategoriState {}

class KategoriLoading extends KategoriState {}

class KategoriLoaded extends KategoriState {
  final List<KategoriResponse> kategoriList;

  KategoriLoaded(this.kategoriList);
}

class KategoriError extends KategoriState {
  final String message;

  KategoriError(this.message);
}
