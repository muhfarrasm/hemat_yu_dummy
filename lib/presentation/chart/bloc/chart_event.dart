part of 'chart_bloc.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

class FetchRingkasanKatPengPie extends ChartEvent {
  final int month;
  final int year;

  const FetchRingkasanKatPengPie({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];
}

class FetchHarianKatPengLine extends ChartEvent {
  final int kategoriId;
  final int month;
  final int year;

  const FetchHarianKatPengLine({
    required this.kategoriId,
    required this.month,
    required this.year,
  });

  @override
  List<Object> get props => [kategoriId, month, year];
}
