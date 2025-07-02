
abstract class TransaksiState {}

class TransaksiInitial extends TransaksiState {}

class TransaksiLoading extends TransaksiState {}

class TransaksiSuccess extends TransaksiState {
  final String message;
  TransaksiSuccess(this.message);
}

class TransaksiError extends TransaksiState {
  final String error;
  TransaksiError(this.error);
}
