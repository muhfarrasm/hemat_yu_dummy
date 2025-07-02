import 'dart:convert';

class RingkasanKatPengPieResponse {
  final String? status;
  final List<KategoriSummary>? data;
  final int? month;
  final int? year;

  RingkasanKatPengPieResponse({
    this.status,
    this.data,
    this.month,
    this.year,
  });

  factory RingkasanKatPengPieResponse.fromJson(String str) =>
      RingkasanKatPengPieResponse.fromMap(json.decode(str));

  factory RingkasanKatPengPieResponse.fromMap(Map<String, dynamic> json) =>
      RingkasanKatPengPieResponse(
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<KategoriSummary>.from(
                json['data'].map((x) => KategoriSummary.fromMap(x))),
        month: json['month'],
        year: json['year'],
      );
}

class KategoriSummary {
  final String? categoryName;
  final double? totalAmount;

  KategoriSummary({
    this.categoryName,
    this.totalAmount,
  });

  factory KategoriSummary.fromMap(Map<String, dynamic> json) =>
      KategoriSummary(
        categoryName: json['category_name'],
        totalAmount: double.tryParse(json['total_amount'] ?? '0') ?? 0.0,
      );
}
