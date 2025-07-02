import 'dart:convert';

class HarianKatPengLineResponse {
  final String? status;
  final String? message;
  final HarianData? data;

  HarianKatPengLineResponse({
    this.status,
    this.message,
    this.data,
  });

  factory HarianKatPengLineResponse.fromJson(String str) =>
      HarianKatPengLineResponse.fromMap(json.decode(str));

  factory HarianKatPengLineResponse.fromMap(Map<String, dynamic> json) =>
      HarianKatPengLineResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null ? HarianData.fromMap(json['data']) : null,
      );
}

class HarianData {
  final int? total;
  final double? presentase;
  final int? sisa;
  final Map<String, int>? dailyData;
  final int? month;
  final int? year;

  HarianData({
    this.total,
    this.presentase,
    this.sisa,
    this.dailyData,
    this.month,
    this.year,
  });

  factory HarianData.fromMap(Map<String, dynamic> json) => HarianData(
        total: json['total'],
        presentase: (json['presentase'] as num?)?.toDouble(),
        sisa: json['sisa'],
        dailyData: Map<String, int>.from(
          json['daily_data']?.map((k, v) => MapEntry(k, v)),
        ),
        month: json['month'],
        year: json['year'],
      );
}
