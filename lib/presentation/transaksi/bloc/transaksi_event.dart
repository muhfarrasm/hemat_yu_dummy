

abstract class TransaksiEvent {}

class SubmitPemasukan extends TransaksiEvent {
  final Map<String, dynamic> data;

  SubmitPemasukan(this.data);
}

class SubmitPengeluaran extends TransaksiEvent {
  final Map<String, dynamic> data;

  SubmitPengeluaran(this.data);
}

class UpdatePemasukan extends TransaksiEvent {
  final int id;
  final Map<String, dynamic> data;

  UpdatePemasukan(this.id, this.data);
}

class UpdatePengeluaran extends TransaksiEvent {
  final int id;
  final Map<String, dynamic> data;

  UpdatePengeluaran(this.id, this.data);
}

class DeleteTransaksi extends TransaksiEvent {
  final bool isPemasukan;
  final int id;

  DeleteTransaksi({required this.id, required this.isPemasukan});
}
