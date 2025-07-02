part of 'chart_bloc.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object?> get props => [];
}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartLoadedPie extends ChartState {
  final RingkasanKatPengPieResponse pieData;

  const ChartLoadedPie({required this.pieData});

  @override
  List<Object?> get props => [pieData];
}

class ChartLoadedLine extends ChartState {
  final HarianKatPengLineResponse lineData;

  const ChartLoadedLine({required this.lineData});

  @override
  List<Object?> get props => [lineData];
}

class ChartError extends ChartState {
  final String message;

  const ChartError({required this.message});

  @override
  List<Object?> get props => [message];
}
