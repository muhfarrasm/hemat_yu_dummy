import 'dart:convert';
import 'package:hematyu_app_dummy_fix/data/model/response/target/target_response.dart';
import 'package:hematyu_app_dummy_fix/service/service_http_client.dart';

class TargetRepository {
  final ServiceHttpClient client;

  TargetRepository(this.client);

  Future<List<TargetResponse>> getTargets() async {
    final response = await client.get('/target', authorized: true);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((e) => TargetResponse.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data target');
    }
  }

  Future<bool> deleteTarget(int id) async {
    final response = await client.delete('/target/$id', authorized: true);
    return response.statusCode == 200;
  }

  // Untuk tambah/edit/delete bisa ditambahkan nanti
}
