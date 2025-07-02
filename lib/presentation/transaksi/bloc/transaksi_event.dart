

abstract class TransaksiEvent {}

class SubmitPemasukan extends TransaksiEvent {
  final Map<String, dynamic> data;

  SubmitPemasukan(this.data);
}

class SubmitPengeluaran extends TransaksiEvent {
  final Map<String, dynamic> data;

  SubmitPengeluaran(this.data);
}