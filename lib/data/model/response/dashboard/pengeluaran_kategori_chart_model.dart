class PengeluaranKategoriChartModel {
  final String categoryName;
  final double totalAmount;

  PengeluaranKategoriChartModel({
    required this.categoryName,
    required this.totalAmount,
  });

  factory PengeluaranKategoriChartModel.fromJson(Map<String, dynamic> json) {
    return PengeluaranKategoriChartModel(
      categoryName: json['category_name'],
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0,
    );
  }
}
