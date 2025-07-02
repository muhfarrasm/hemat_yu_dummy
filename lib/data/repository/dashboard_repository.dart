import 'dart:convert';

import 'package:hematyu_app_dummy_fix/data/model/response/dashboard/dashboard_model.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';
import 'package:hematyu_app_dummy_fix/data/model/response/auth/me_response_model.dart';

class DashboardRepository {
  final ServiceHttpClient httpClient;

  DashboardRepository({required this.httpClient});

  Future<MeResponseModel> getProfile(String token) async {
    final response = await httpClient.get(
      '/auth/me',
       authorized: true,
    );
    final jsonMap = jsonDecode(response.body);
    return MeResponseModel.fromJson(jsonMap);
  }

  Future<TotalPemasukanResponse> getTotalPemasukanMonthly(
      String token, int month, int year) async {
    final response = await httpClient.get(
      '/pemasukan/total/monthly?month=$month&year=$year',
     authorized: true,
    );
    final jsonMap = jsonDecode(response.body);
    return TotalPemasukanResponse.fromJson(jsonMap);
  }
}